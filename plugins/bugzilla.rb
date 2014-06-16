<!DOCTYPE html>
<html class="  ">
<head prefix="og: http://ogp.me/ns# fb: http://ogp.me/ns/fb# githubog: http://ogp.me/ns/fb/githubog#">
  <meta charset="utf-8">
  <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">

  <title>bugzilla.rb</title>

  <meta content="authenticity_token" name="csrf-param" />
<meta content="KXKI7IBdMwuOyaQsVHwqi8rRh2t+Wn2HqKGu7HEd+k7/vc2ZkdJ+C9Av4WmbKsVMx3jnhHpkJPUZ48SYnUxSgQ==" name="csrf-token" />
  <meta name="viewport" content="width=960">


    <link type="text/plain" rel="author" href="https://github.com/humans.txt" />
    <meta content="gist" name="octolytics-app-id" /><meta content="collector.githubapp.com" name="octolytics-host" /><meta content="collector-cdn.github.com" name="octolytics-script-host" /><meta content="44922802:4109:415E6B4:539F5A54" name="octolytics-dimension-request_id" />
  <link rel="assets" href="https://gist-assets.github.com/">
  

  <link href="https://gist-assets.github.com/assets/application-559835edae9e86b712a6ca8d222edbc7.css" media="screen, print" rel="stylesheet" />
  <script src="https://gist-assets.github.com/assets/application-1c8b7dee22eaf5ec91435a18c88c8fde.js"></script>

      <meta name="twitter:card" content="summary">
  <meta name="twitter:site" content="@github">
  <meta property="og:title" content="tarasglek/bugzilla.rb">
  <meta property="og:type" content="githubog:gist">
  <meta property="og:url" content="https://gist.github.com/tarasglek/5800309">
  <meta property="og:image" content="https://avatars3.githubusercontent.com/u/857083?s=140">
  <meta property="og:site_name" content="GitHub Gists">
  <meta property="og:description" content=" - Gist is a simple way to share snippets of text and code with others.">
  <meta name="description" content=" - Gist is a simple way to share snippets of text and code with others.">


</head>

<body class=" "
  data-plan="">

  <div id="wrapper">
    

    <div id="header" class="header header-logged-out">
      <div class="container" class="clearfix">
        <a class="header-logo-wordmark" href="https://gist.github.com/">
          <span class="octicon octicon-logo-github"></span>
          <span class="octicon-logo octicon-logo-gist"></span>
        </a>

        <div class="header-actions">
          <a class="button primary" href="https://github.com/signup?return_to=gist">Sign up for a GitHub account</a>
          <a class="button" href="https://gist.github.com/login?return_to=%2Ftarasglek%2F5800309" data-skip-pjax>Sign in</a>
        </div>
        <div class="divider-vertical"></div>
        <div class="topsearch">
  <form id="top_search_form" action="/search" data-pjax-remote=push accept-charset="UTF-8">
    <div class="search">
      <input type="text" class="search js-search js-navigation-enable " name="q" placeholder="Search&#x2026;" data-hotkey="/" autocomplete=off autocorrect=off value="" >

    </div>
    <div class="divider-vertical"></div>
  </form>
  <ul class="top-nav">
    <li class="explore"><a href="/discover">All Gists</a></li>
  </ul>
</div>

      </div>
    </div>

    <div class="site-content" id="js-pjax-container" data-pjax-container>
      <div id="js-flash-container" class="site-container js-site-container" data-url="/tarasglek/5800309">
  
  

<meta content="true" name="octolytics-dimension-public" /><meta content="5800309" name="octolytics-dimension-gist_id" /><meta content="5800309" name="octolytics-dimension-gist_name" /><meta content="false" name="octolytics-dimension-anonymous" /><meta content="857083" name="octolytics-dimension-owner_id" /><meta content="tarasglek" name="octolytics-dimension-owner_login" /><meta content="false" name="octolytics-dimension-forked" />

<div class="pagehead repohead">
  <div class="container">
    <div class="title-actions-bar">
      <ul class="pagehead-actions">


      </ul>
      <h1 itemscope itemtype="http://data-vocabulary.org/Breadcrumb" class="entry-title public" >
  <span class="repo-label"><span class="" >public</span></span>
  <span class="mega-octicon octicon-gist" ></span>
  <div class="meta">
    <div class="gist-author">
      <img src="https://avatars3.githubusercontent.com/u/857083?s=140" width="26" height="26">
        <span class="author vcard">
            <span itemprop="title"><a href="/tarasglek">tarasglek</a></span>
        </span> /
      <strong><a href="/tarasglek/5800309" class="js-current-repository">bugzilla.rb</a></strong>
    </div>
    <div class="gist-timestamp">
        <span class="datetime">Created <time class="js-relative-date" title="2013-06-17T20:54:51Z" datetime="2013-06-17T20:54:51Z">2013-06-17</time></span>
    </div>
</h1>

    </div>

  </div>
</div>


<div class="container">
  <div class="gist js-gist-container gist-with-sidebar with-full-navigation"
    data-version="84c237f7e6d55fcb0b3f49026c61f711fcaa2771"
    data-created="false"
    data-updated="false">

      <div class="gist-sidebar clearfix">
  <div class="sunken-menu vertical-right repo-nav js-repo-nav js-repository-container-pjax js-octicon-loaders">
    <div class="sunken-menu-contents">
      <ul class="sunken-menu-group">
        <li class="tooltipped tooltipped-w" aria-label="Code">
          <a aria-label="Code" class="sunken-menu-item selected" data-pjax="true" href="/tarasglek/5800309">
            <span class="octicon octicon-code"></span> <span class="full-word">Code</span>
            <img alt="" class="mini-loader" height="16" src="https://gist-assets.github.com/assets/spinners/octocat-spinner-32-c4edb5be6eba969fb23f69e93308974e.gif" width="16" />
</a>        </li>

          <li class="tooltipped tooltipped-w" aria-label="Revisions">
            <a aria-label="Revisions" class="sunken-menu-item" data-pjax="true" href="/tarasglek/5800309/revisions">
              <span class="octicon octicon-git-commit"></span> <span class="full-word">Revisions</span>
              <img alt="" class="mini-loader" height="16" src="https://gist-assets.github.com/assets/spinners/octocat-spinner-32-c4edb5be6eba969fb23f69e93308974e.gif" width="16" />
              <span class='counter'>1</span>
</a>          </li>


      </ul>
    </div><!-- /.sunken-menu-group -->
  </div><!-- /.sunken-menu-contents -->

  <div class="only-with-full-nav">

    <div class="embed-url open" style="display: block;">
      <h3><strong>Embed</strong> URL</h3>
      <div class="clone-url-box">
        <input type="text" class="clone js-url-field" value="&lt;script src=&quot;https://gist.github.com/tarasglek/5800309.js&quot;&gt;&lt;/script&gt;" readonly="readonly">
        <span class="url-box-clippy">
          <button aria-label="copy to clipboard" class="js-zeroclipboard minibutton zeroclipboard-button" data-clipboard-text="&lt;script src=&quot;https://gist.github.com/tarasglek/5800309.js&quot;&gt;&lt;/script&gt;" data-copied-hint="copied!" type="button"><span class="octicon octicon-clippy"></span></button>
        </span>
      </div>
    </div>
    <p class="clone-options"></p>

      
<div class="clone-url open" data-protocol-type="http" data-url="https://gist.github.com/5800309.git">
  <h3><strong>HTTPS</strong> clone URL</h3>
  <div class="clone-url-box">
    <input type="text" class="clone url-field js-url-field" value="https://gist.github.com/5800309.git" readonly="readonly">
    <span class="url-box-clippy">
      <button aria-label="copy to clipboard" class="js-zeroclipboard minibutton zeroclipboard-button" data-clipboard-text="https://gist.github.com/5800309.git" data-copied-hint="copied!" type="button"><span class="octicon octicon-clippy"></span></button>
    </span>
  </div>
</div>

  
<div class="clone-url " data-protocol-type="ssh" data-url="git@gist.github.com:/5800309.git">
  <h3><strong>SSH</strong> clone URL</h3>
  <div class="clone-url-box">
    <input type="text" class="clone url-field js-url-field" value="git@gist.github.com:/5800309.git" readonly="readonly">
    <span class="url-box-clippy">
      <button aria-label="copy to clipboard" class="js-zeroclipboard minibutton zeroclipboard-button" data-clipboard-text="git@gist.github.com:/5800309.git" data-copied-hint="copied!" type="button"><span class="octicon octicon-clippy"></span></button>
    </span>
  </div>
</div>


<p class="clone-options">You can clone with
      <a href="#" class="js-clone-selector" data-protocol="http">HTTPS</a>
      or <a href="#" class="js-clone-selector" data-protocol="ssh">SSH</a>.
</p>


    <a aria-label="Download bugzilla.rb as a zip file" class="minibutton sidebar-button" href="/tarasglek/5800309/download" rel="nofollow" title="Download bugzilla.rb as a zip file">
      <span class="octicon octicon-cloud-download"></span>
      Download Gist
</a>  </div><!-- /.only-with-full-nav -->

</div>


    <div class="gist-content">

      <div class="files">
            <div id="file-bugzilla-rb" class="file ">
  <div class="meta clearfix">
    <div class="info file-name">
      <span class="icon">
        <b class="octicon octicon-gist"></b>
      </span>
      <a aria-label="Permalink" href="#file-bugzilla-rb" class="tooltipped tooltipped-s permalink"><strong class="file-name js-selectable-text">bugzilla.rb</strong></a>
    </div>
    <div class="actions">
      <div class="button-group">
        <a aria-label="View Raw"
          href="/tarasglek/5800309/raw/a6ee20a4521cd9dead188e519fc9a253944714bc/bugzilla.rb"
          data-skip-pjax class="minibutton raw-url js-view-raw">Raw</a>
      </div>
    </div>
  </div>
  <div class="suppressed">
    <a class="js-show-suppressed-file">File suppressed. Click to show.</a>
  </div>
  <div class="blob-wrapper data type-ruby js-blob-data">
    



    <div class="file-data">
      <table cellpadding="0" cellspacing="0" class="lines highlight">
        <tr>
          <td class="line-numbers">
            <span class="line-number" id="file-bugzilla-rb-L1" rel="file-bugzilla-rb-L1">1</span>
            <span class="line-number" id="file-bugzilla-rb-L2" rel="file-bugzilla-rb-L2">2</span>
            <span class="line-number" id="file-bugzilla-rb-L3" rel="file-bugzilla-rb-L3">3</span>
            <span class="line-number" id="file-bugzilla-rb-L4" rel="file-bugzilla-rb-L4">4</span>
            <span class="line-number" id="file-bugzilla-rb-L5" rel="file-bugzilla-rb-L5">5</span>
            <span class="line-number" id="file-bugzilla-rb-L6" rel="file-bugzilla-rb-L6">6</span>
            <span class="line-number" id="file-bugzilla-rb-L7" rel="file-bugzilla-rb-L7">7</span>
            <span class="line-number" id="file-bugzilla-rb-L8" rel="file-bugzilla-rb-L8">8</span>
            <span class="line-number" id="file-bugzilla-rb-L9" rel="file-bugzilla-rb-L9">9</span>
            <span class="line-number" id="file-bugzilla-rb-L10" rel="file-bugzilla-rb-L10">10</span>
            <span class="line-number" id="file-bugzilla-rb-L11" rel="file-bugzilla-rb-L11">11</span>
            <span class="line-number" id="file-bugzilla-rb-L12" rel="file-bugzilla-rb-L12">12</span>
            <span class="line-number" id="file-bugzilla-rb-L13" rel="file-bugzilla-rb-L13">13</span>
            <span class="line-number" id="file-bugzilla-rb-L14" rel="file-bugzilla-rb-L14">14</span>
            <span class="line-number" id="file-bugzilla-rb-L15" rel="file-bugzilla-rb-L15">15</span>
            <span class="line-number" id="file-bugzilla-rb-L16" rel="file-bugzilla-rb-L16">16</span>
            <span class="line-number" id="file-bugzilla-rb-L17" rel="file-bugzilla-rb-L17">17</span>
            <span class="line-number" id="file-bugzilla-rb-L18" rel="file-bugzilla-rb-L18">18</span>
            <span class="line-number" id="file-bugzilla-rb-L19" rel="file-bugzilla-rb-L19">19</span>
            <span class="line-number" id="file-bugzilla-rb-L20" rel="file-bugzilla-rb-L20">20</span>
            <span class="line-number" id="file-bugzilla-rb-L21" rel="file-bugzilla-rb-L21">21</span>
            <span class="line-number" id="file-bugzilla-rb-L22" rel="file-bugzilla-rb-L22">22</span>
            <span class="line-number" id="file-bugzilla-rb-L23" rel="file-bugzilla-rb-L23">23</span>
            <span class="line-number" id="file-bugzilla-rb-L24" rel="file-bugzilla-rb-L24">24</span>
            <span class="line-number" id="file-bugzilla-rb-L25" rel="file-bugzilla-rb-L25">25</span>
            <span class="line-number" id="file-bugzilla-rb-L26" rel="file-bugzilla-rb-L26">26</span>
            <span class="line-number" id="file-bugzilla-rb-L27" rel="file-bugzilla-rb-L27">27</span>
            <span class="line-number" id="file-bugzilla-rb-L28" rel="file-bugzilla-rb-L28">28</span>
            <span class="line-number" id="file-bugzilla-rb-L29" rel="file-bugzilla-rb-L29">29</span>
            <span class="line-number" id="file-bugzilla-rb-L30" rel="file-bugzilla-rb-L30">30</span>
            <span class="line-number" id="file-bugzilla-rb-L31" rel="file-bugzilla-rb-L31">31</span>
            <span class="line-number" id="file-bugzilla-rb-L32" rel="file-bugzilla-rb-L32">32</span>
            <span class="line-number" id="file-bugzilla-rb-L33" rel="file-bugzilla-rb-L33">33</span>
            <span class="line-number" id="file-bugzilla-rb-L34" rel="file-bugzilla-rb-L34">34</span>
            <span class="line-number" id="file-bugzilla-rb-L35" rel="file-bugzilla-rb-L35">35</span>
            <span class="line-number" id="file-bugzilla-rb-L36" rel="file-bugzilla-rb-L36">36</span>
            <span class="line-number" id="file-bugzilla-rb-L37" rel="file-bugzilla-rb-L37">37</span>
            <span class="line-number" id="file-bugzilla-rb-L38" rel="file-bugzilla-rb-L38">38</span>
            <span class="line-number" id="file-bugzilla-rb-L39" rel="file-bugzilla-rb-L39">39</span>
            <span class="line-number" id="file-bugzilla-rb-L40" rel="file-bugzilla-rb-L40">40</span>
            <span class="line-number" id="file-bugzilla-rb-L41" rel="file-bugzilla-rb-L41">41</span>
            <span class="line-number" id="file-bugzilla-rb-L42" rel="file-bugzilla-rb-L42">42</span>
            <span class="line-number" id="file-bugzilla-rb-L43" rel="file-bugzilla-rb-L43">43</span>
            <span class="line-number" id="file-bugzilla-rb-L44" rel="file-bugzilla-rb-L44">44</span>
            <span class="line-number" id="file-bugzilla-rb-L45" rel="file-bugzilla-rb-L45">45</span>
            <span class="line-number" id="file-bugzilla-rb-L46" rel="file-bugzilla-rb-L46">46</span>
            <span class="line-number" id="file-bugzilla-rb-L47" rel="file-bugzilla-rb-L47">47</span>
            <span class="line-number" id="file-bugzilla-rb-L48" rel="file-bugzilla-rb-L48">48</span>
            <span class="line-number" id="file-bugzilla-rb-L49" rel="file-bugzilla-rb-L49">49</span>
            <span class="line-number" id="file-bugzilla-rb-L50" rel="file-bugzilla-rb-L50">50</span>
            <span class="line-number" id="file-bugzilla-rb-L51" rel="file-bugzilla-rb-L51">51</span>
            <span class="line-number" id="file-bugzilla-rb-L52" rel="file-bugzilla-rb-L52">52</span>
            <span class="line-number" id="file-bugzilla-rb-L53" rel="file-bugzilla-rb-L53">53</span>
            <span class="line-number" id="file-bugzilla-rb-L54" rel="file-bugzilla-rb-L54">54</span>
            <span class="line-number" id="file-bugzilla-rb-L55" rel="file-bugzilla-rb-L55">55</span>
            <span class="line-number" id="file-bugzilla-rb-L56" rel="file-bugzilla-rb-L56">56</span>
            <span class="line-number" id="file-bugzilla-rb-L57" rel="file-bugzilla-rb-L57">57</span>
            <span class="line-number" id="file-bugzilla-rb-L58" rel="file-bugzilla-rb-L58">58</span>
            <span class="line-number" id="file-bugzilla-rb-L59" rel="file-bugzilla-rb-L59">59</span>
            <span class="line-number" id="file-bugzilla-rb-L60" rel="file-bugzilla-rb-L60">60</span>
            <span class="line-number" id="file-bugzilla-rb-L61" rel="file-bugzilla-rb-L61">61</span>
            <span class="line-number" id="file-bugzilla-rb-L62" rel="file-bugzilla-rb-L62">62</span>
            <span class="line-number" id="file-bugzilla-rb-L63" rel="file-bugzilla-rb-L63">63</span>
            <span class="line-number" id="file-bugzilla-rb-L64" rel="file-bugzilla-rb-L64">64</span>
          </td>
          <td class="line-data">
            <pre class="line-pre"><div class="line" id="file-bugzilla-rb-LC1"><span class="c1"># add +gem &#39;rest-client&#39;, &#39;1.6.7&#39;, :require =&gt; &#39;rest_client&#39; to Gemfile</span></div><div class="line" id="file-bugzilla-rb-LC2"><span class="c1"># drop this file into plugins</span></div><div class="line" id="file-bugzilla-rb-LC3"><span class="c1"># use {%bug ######%} or {%Bug ######%} for capitalization</span></div><div class="line" id="file-bugzilla-rb-LC4">&nbsp;</div><div class="line" id="file-bugzilla-rb-LC5">&nbsp;</div><div class="line" id="file-bugzilla-rb-LC6"><span class="nb">require</span> <span class="s1">&#39;rest_client&#39;</span></div><div class="line" id="file-bugzilla-rb-LC7"><span class="nb">require</span> <span class="s1">&#39;json&#39;</span></div><div class="line" id="file-bugzilla-rb-LC8">&nbsp;</div><div class="line" id="file-bugzilla-rb-LC9"><span class="k">module</span> <span class="nn">Bugzilla</span></div><div class="line" id="file-bugzilla-rb-LC10">  <span class="no">SERVER</span> <span class="o">=</span> <span class="s2">&quot;https://api-dev.bugzilla.mozilla.org/1.2/&quot;</span></div><div class="line" id="file-bugzilla-rb-LC11">  <span class="vi">@network_is_busted</span> <span class="o">=</span> <span class="kp">false</span></div><div class="line" id="file-bugzilla-rb-LC12">&nbsp;</div><div class="line" id="file-bugzilla-rb-LC13">  <span class="k">def</span> <span class="nc">Bugzilla</span><span class="o">.</span><span class="nf">bug</span> <span class="p">(</span><span class="n">bug_no</span><span class="p">)</span></div><div class="line" id="file-bugzilla-rb-LC14">    <span class="n">url</span> <span class="o">=</span> <span class="no">Bugzilla</span><span class="o">::</span><span class="no">SERVER</span> <span class="o">+</span> <span class="s2">&quot;bug/</span><span class="si">#{</span><span class="n">bug_no</span><span class="si">}</span><span class="s2">&quot;</span></div><div class="line" id="file-bugzilla-rb-LC15">    <span class="n">file</span> <span class="o">=</span> <span class="s2">&quot;/tmp/bug.</span><span class="si">#{</span><span class="n">bug_no</span><span class="si">}</span><span class="s2">&quot;</span></div><div class="line" id="file-bugzilla-rb-LC16">    <span class="k">begin</span></div><div class="line" id="file-bugzilla-rb-LC17">      <span class="n">response</span> <span class="o">=</span> <span class="no">File</span><span class="o">.</span><span class="n">read</span> <span class="n">file</span></div><div class="line" id="file-bugzilla-rb-LC18">    <span class="k">rescue</span> <span class="no">Errno</span><span class="o">::</span><span class="no">ENOENT</span></div><div class="line" id="file-bugzilla-rb-LC19">      <span class="nb">print</span> <span class="s2">&quot;fetching </span><span class="si">#{</span><span class="n">url</span><span class="si">}</span><span class="se">\n</span><span class="s2">&quot;</span></div><div class="line" id="file-bugzilla-rb-LC20">      <span class="n">response</span> <span class="o">=</span> <span class="s2">&quot;&quot;</span></div><div class="line" id="file-bugzilla-rb-LC21">      <span class="k">if</span> <span class="ow">not</span> <span class="vi">@network_is_busted</span> <span class="k">then</span></div><div class="line" id="file-bugzilla-rb-LC22">        <span class="k">begin</span></div><div class="line" id="file-bugzilla-rb-LC23">          <span class="n">response</span> <span class="o">=</span> <span class="o">::</span><span class="no">RestClient</span><span class="o">.</span><span class="n">get</span> <span class="n">url</span></div><div class="line" id="file-bugzilla-rb-LC24">          <span class="c1"># handle timeouts, etc</span></div><div class="line" id="file-bugzilla-rb-LC25">        <span class="k">rescue</span></div><div class="line" id="file-bugzilla-rb-LC26">          <span class="n">network_is_busted</span> <span class="o">=</span> <span class="kp">true</span><span class="p">;</span></div><div class="line" id="file-bugzilla-rb-LC27">          <span class="nb">print</span> <span class="s2">&quot;Failed to fetch </span><span class="si">#{</span><span class="n">url</span><span class="si">}</span><span class="s2">. @network_is_busted time</span><span class="se">\n</span><span class="s2">&quot;</span></div><div class="line" id="file-bugzilla-rb-LC28">        <span class="k">end</span></div><div class="line" id="file-bugzilla-rb-LC29">      <span class="k">end</span></div><div class="line" id="file-bugzilla-rb-LC30">      <span class="n">response</span> <span class="o">=</span> <span class="s1">&#39;{&quot;summary&quot;:&quot;&quot;}&#39;</span> <span class="k">if</span> <span class="vi">@network_is_busted</span></div><div class="line" id="file-bugzilla-rb-LC31">      <span class="o">::</span><span class="no">File</span><span class="o">.</span><span class="n">open</span><span class="p">(</span><span class="n">file</span><span class="p">,</span> <span class="s1">&#39;w&#39;</span><span class="p">)</span> <span class="p">{</span><span class="o">|</span><span class="n">f</span><span class="o">|</span> <span class="n">f</span><span class="o">.</span><span class="n">write</span><span class="p">(</span><span class="n">response</span><span class="o">.</span><span class="n">to_str</span><span class="p">)</span> <span class="p">}</span></div><div class="line" id="file-bugzilla-rb-LC32">    <span class="k">end</span></div><div class="line" id="file-bugzilla-rb-LC33">    <span class="k">return</span> <span class="no">JSON</span><span class="o">.</span><span class="n">parse</span><span class="p">(</span><span class="n">response</span><span class="p">)</span></div><div class="line" id="file-bugzilla-rb-LC34">  <span class="k">end</span></div><div class="line" id="file-bugzilla-rb-LC35"><span class="k">end</span></div><div class="line" id="file-bugzilla-rb-LC36">&nbsp;</div><div class="line" id="file-bugzilla-rb-LC37"><span class="k">module</span> <span class="nn">Jekyll</span></div><div class="line" id="file-bugzilla-rb-LC38">  <span class="k">class</span> <span class="nc">Bugzilla</span> <span class="o">&lt;</span> <span class="no">Liquid</span><span class="o">::</span><span class="no">Tag</span></div><div class="line" id="file-bugzilla-rb-LC39">    <span class="vi">@bugno</span> <span class="o">=</span> <span class="s2">&quot;&quot;</span></div><div class="line" id="file-bugzilla-rb-LC40">    <span class="vi">@tagname</span> <span class="o">=</span> <span class="s2">&quot;&quot;</span></div><div class="line" id="file-bugzilla-rb-LC41">    <span class="vi">@extra</span> <span class="o">=</span> <span class="s2">&quot;&quot;</span></div><div class="line" id="file-bugzilla-rb-LC42">    <span class="vi">@title</span> <span class="o">=</span> <span class="s2">&quot;&quot;</span></div><div class="line" id="file-bugzilla-rb-LC43">    </div><div class="line" id="file-bugzilla-rb-LC44">    <span class="k">def</span> <span class="nf">initialize</span><span class="p">(</span><span class="n">tagname</span><span class="p">,</span> <span class="n">bugno</span><span class="p">,</span> <span class="n">tokens</span><span class="p">)</span></div><div class="line" id="file-bugzilla-rb-LC45">      <span class="vi">@tagname</span> <span class="o">=</span> <span class="n">tagname</span><span class="o">.</span><span class="n">strip</span><span class="p">()</span></div><div class="line" id="file-bugzilla-rb-LC46">      <span class="n">cmd</span> <span class="o">=</span> <span class="n">bugno</span><span class="o">.</span><span class="n">split</span><span class="p">(</span><span class="s1">&#39; &#39;</span><span class="p">)</span></div><div class="line" id="file-bugzilla-rb-LC47">      <span class="vi">@bugno</span> <span class="o">=</span> <span class="n">cmd</span><span class="o">[</span><span class="mi">0</span><span class="o">]</span></div><div class="line" id="file-bugzilla-rb-LC48">      <span class="n">bug</span> <span class="o">=</span> <span class="o">::</span><span class="no">Bugzilla</span><span class="o">.</span><span class="n">bug</span><span class="p">(</span><span class="vi">@bugno</span><span class="p">)</span></div><div class="line" id="file-bugzilla-rb-LC49">      <span class="vi">@extra</span> <span class="o">=</span> <span class="s2">&quot;&quot;</span></div><div class="line" id="file-bugzilla-rb-LC50">      <span class="k">if</span> <span class="n">cmd</span><span class="o">.</span><span class="n">length</span> <span class="o">&gt;</span> <span class="mi">1</span> <span class="k">then</span></div><div class="line" id="file-bugzilla-rb-LC51">        <span class="vi">@extra</span> <span class="o">=</span> <span class="s2">&quot;: &quot;</span> <span class="o">+</span> <span class="n">bug</span><span class="o">[</span><span class="n">cmd</span><span class="o">[</span><span class="mi">1</span><span class="o">]]</span></div><div class="line" id="file-bugzilla-rb-LC52">      <span class="k">end</span></div><div class="line" id="file-bugzilla-rb-LC53">      <span class="vi">@title</span> <span class="o">=</span> <span class="s2">&quot;title=</span><span class="se">\&quot;</span><span class="s2">&quot;</span> <span class="o">+</span> <span class="n">bug</span><span class="o">[</span><span class="s2">&quot;summary&quot;</span><span class="o">]</span> <span class="o">+</span> <span class="s2">&quot;</span><span class="se">\&quot;</span><span class="s2">&quot;</span></div><div class="line" id="file-bugzilla-rb-LC54">    <span class="k">end</span></div><div class="line" id="file-bugzilla-rb-LC55">&nbsp;</div><div class="line" id="file-bugzilla-rb-LC56">    <span class="k">def</span> <span class="nf">render</span><span class="p">(</span><span class="n">conbugno</span><span class="p">)</span></div><div class="line" id="file-bugzilla-rb-LC57">      <span class="s2">&quot;&lt;a </span><span class="si">#{</span><span class="vi">@title</span><span class="si">}</span><span class="s2"> href=</span><span class="se">\&quot;</span><span class="s2">https://bugzilla.mozilla.org/show_bug.cgi?id=</span><span class="si">#{</span><span class="vi">@bugno</span><span class="si">}</span><span class="se">\&quot;</span><span class="s2">&gt;</span><span class="si">#{</span><span class="vi">@tagname</span><span class="si">}</span><span class="s2"> </span><span class="si">#{</span><span class="vi">@bugno</span><span class="si">}</span><span class="s2">&lt;/a&gt;&quot;</span> <span class="o">+</span> <span class="vi">@extra</span></div><div class="line" id="file-bugzilla-rb-LC58">    <span class="k">end</span></div><div class="line" id="file-bugzilla-rb-LC59">&nbsp;</div><div class="line" id="file-bugzilla-rb-LC60">  <span class="k">end</span></div><div class="line" id="file-bugzilla-rb-LC61"><span class="k">end</span></div><div class="line" id="file-bugzilla-rb-LC62">&nbsp;</div><div class="line" id="file-bugzilla-rb-LC63"><span class="no">Liquid</span><span class="o">::</span><span class="no">Template</span><span class="o">.</span><span class="n">register_tag</span><span class="p">(</span><span class="s1">&#39;bug&#39;</span><span class="p">,</span> <span class="no">Jekyll</span><span class="o">::</span><span class="no">Bugzilla</span><span class="p">)</span></div><div class="line" id="file-bugzilla-rb-LC64"><span class="no">Liquid</span><span class="o">::</span><span class="no">Template</span><span class="o">.</span><span class="n">register_tag</span><span class="p">(</span><span class="s1">&#39;Bug&#39;</span><span class="p">,</span> <span class="no">Jekyll</span><span class="o">::</span><span class="no">Bugzilla</span><span class="p">)</span></div></pre>
          </td>
        </tr>
      </table>
    </div>

  </div>
</div>


        <div class="discussion-timeline js-quote-selection-container">

          <div class="js-discussion">
            
          </div>

          <div class="discussion-timeline-actions">
              <div class="signed-out-comment">
	<a class="button primary" href="https://github.com/signup?return_to=gist" rel="nofollow">Sign up for free</a>
	<strong>to join this conversation on GitHub</strong>.
	Already have an account?
  <a href="https://gist.github.com/login?return_to=%2Ftarasglek%2F5800309" rel="nofollow">Sign in to comment</a>
</div>


          </div>
        </div><!-- /.discussion-timeline -->
      </div><!-- /.gist-content -->
    </div>
  </div>
</div><!-- /.container -->

  <div class="context-overlay"></div>
</div>

    </div>
    <div class="slow-loading-overlay"></div>
  </div>

  <div id="ajax-error-message" class="flash flash-error">
    <div class="container">
      <span class="octicon octicon-alert"></span>
      Something went wrong with that request. Please try again.
      <a href="#" class="octicon octicon-x ajax-error-dismiss"></a>
    </div>
  </div>


  <footer>
    <div class="container">
  <div class="site-footer">
    <ul class="site-footer-links right">
      <li><a href="https://status.github.com/">Status</a></li>
      <li><a href="http://developer.github.com">API</a></li>
      <li><a href="https://github.com/blog">Blog</a></li>
      <li><a href="https://github.com/about">About</a></li>

    </ul>

    <a href="/">
      <span class="mega-octicon octicon-mark-github" title="GitHub "></span>
    </a>

    <ul class="site-footer-links">
      <li>&copy; 2014 <span title="0.01894s from github-fe102-cp1-prd.iad.github.net">GitHub</span>, Inc.</li>
        <li><a href="https://github.com/site/terms">Terms</a></li>
        <li><a href="https://github.com/site/privacy">Privacy</a></li>
        <li><a href="https://github.com/security">Security</a></li>
        <li><a href="https://github.com/contact">Contact</a></li>
    </ul>
  </div><!-- /.site-footer -->
</div><!-- /.container -->

  </footer>

  <div class="fullscreen-overlay js-fullscreen-overlay" id="fullscreen_overlay">
  <div class="fullscreen-container js-fullscreen-container">
    <div class="textarea-wrap">
      <textarea name="fullscreen-contents" id="fullscreen-contents" class="fullscreen-contents js-fullscreen-contents" placeholder="" data-suggester="fullscreen_suggester"></textarea>
        <div class="suggester-container">
            <div class="suggester fullscreen-suggester js-navigation-container" id="fullscreen_suggester"
                data-url="/tarasglek/5800309/suggestions">
            </div>
        </div>
    </div>
  </div>
  <div class="fullscreen-sidebar">
    <a href="#" class="exit-fullscreen js-exit-fullscreen tooltipped tooltipped-w" aria-label="Exit Zen Mode">
      <span class="mega-octicon octicon-screen-normal"></span>
    </a>
    <a href="#" class="theme-switcher js-theme-switcher tooltipped tooltipped-w"
      aria-label="Switch themes">
      <span class="octicon octicon-color-mode"></span>
    </a>
  </div>
</div>


</body>
</html>
