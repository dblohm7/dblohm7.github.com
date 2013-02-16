#!/bin/bash
rake generate && rake deploy
git add .
git commit
git push origin source
