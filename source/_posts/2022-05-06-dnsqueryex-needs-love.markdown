---
layout: post
title: "DnsQueryEx needs love"
date: 2022-05-06 17:40:00 -0600
comments: true
categories: [Debugging, Win32]
---
Recently I've been doing some work with [`DnsQueryEx`](https://web.archive.org/web/20220107041650/https://docs.microsoft.com/en-us/windows/win32/api/windns/nf-windns-dnsqueryex),
but unfortunately this has been less than pleasant. Not only are there errors in its documentation,
but the API itself contains a bug that IMHO should never have made it to release.

Like many other Win32 APIs, `DnsQueryEx` is an asynchronous interface that also
supports being called synchronously. Whether their completion mechanism uses an
event object, an APC, an I/O Completion Port, or some other technique,
asynchronous Win32 APIs consistently employ a common convention:

When a caller invokes the API, and that API is able to execute asynchronously,
it returns `ERROR_IO_PENDING`. On the other hand, when the API fails, the API is
able to immediately satisfy the request, or the API was invoked synchronously,
the function immediately returns the final error code.

For emphasis: **In Win32, most asynchronous APIs reserve the right to complete
synchronously if they are able to immediately satisfy a request.**

Enter `DnsQueryEx`: while its internal implementation follows this convention,
the implementation of its public interface does not!

This is really easy to reproduce (on a fully-updated Windows 10 21H1, at least)
by setting up an asynchronous call to `DnsQueryEx`, and querying for `"localhost"`.
The caller must populate the `pQueryCompletionCallback` field in the [`DNS_QUERY_REQUEST`](https://web.archive.org/web/20220107051448/https://docs.microsoft.com/en-us/windows/win32/api/windns/ns-windns-dns_query_request)
structure.

`DnsQueryEx` returns `ERROR_SUCCESS`. Great, the asynchronous API was able to
immediately fulfill the request!

Everything works according to plan until we examine the `pQueryRecords` field of
the [`DNS_QUERY_RESULT`](https://web.archive.org/web/20220106224652/https://docs.microsoft.com/en-us/windows/win32/api/windns/ns-windns-dns_query_result)
structure. That field is `NULL`! Every other output from this function points to
a successful query, and yet we receive no results!

I spent several hours pouring over the documentation and attempting different
permutations of the `localhost` query, however the only way that I could coerce
`DnsQueryEx` to actually produce the expected output is if I invoked it
synchronously.

I finally determined that this poking around was becoming futile and decided to
examine the disassembly. Here's some (highly-simplified) pseudocode of what I found:

``` c++
  // Inside DnsQueryEx
  bool isSynchronous = pQueryRequest->pQueryCompletionCallback == nullptr;
  PDNS_QUERY_RESULT internalDnsQueryResult = /*<make private copy of pQueryResults>*/;
  // Call internal implementation. It returns the same error codes as DnsQueryEx
  DWORD win32ErrorCode = Query_PrivateExW(pQueryRequest, internalDnsQueryResult);
  if (isSynchronous) {
    memcpy(pQueryResult, internalDnsQueryResult, sizeof(DNS_QUERY_RESULT));
    return win32ErrorCode;
  }
  // Otherwise we're executing asynchronously, continue on that path...
```

Based on the background that I outlined above, do you see the bug?







I'll give you a hint: `ERROR_IO_PENDING`.







See it now?







Okay, here goes: `isSynchronous` is the wrong condition for determining
whether to copy the internal records to `pQueryResult` and immediately
return! In fact, I would argue that `isSynchronous` should not be checked at
all: instead, `DnsQueryEx` should be checking that `win32ErrorCode != ERROR_IO_PENDING`!

To add insult to injury, `Query_PrivateExW` correctly allocates the output
records from the heap, so `DnsQueryEx` is effectively leaking them.

I'm going to try reporting this issue via Feedback Hub, but if any Microsofties
see this, I'd appreciate it if you could flag the maintainer of `dnsapi.dll` and
get this fixed.

I suppose one workaround is to look for a successful call to `DnsQueryEx` with
`NULL` records, and then fall back to invoking it synchronously. On the other
hand, that doesn't help with the memory leak.

Another gross, hacky option could be to manually check for special queries like
`localhost` prior to calling the API, but this isn't exhaustive: there could
be other reasons that `Query_PrivateExW` decides to execute synchronously.

As you can see, this is a pretty trivial test case, which is why I find this
bug to be so disappointing. I am a big proponent of attributing bugs to an OS
until I have proof otherwise, but the disassembly I encountered was pretty
damning.

Hopefully this gets fixed. Until next time...

**UPDATE:** Microsoft's Tommy Jensen [noted](https://twitter.com/tommyatms/status/1523732124343304193)
that this bug has been fixed in Windows 11, but unfortunately [will not](https://twitter.com/tommyatms/status/1523735004009820165)
be backported to Windows 10. Thanks to Brad Fitzpatrick for amplifying this post on Twitter.

