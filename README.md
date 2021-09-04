Laravel (Or Composer + NPM) CI
==============================

Overview
--------

This project contains a build script and a some additional files that might  
you set up a git based continuous integration environment for your Laravel  
or any other project that involves composer and npm.

The goal of this project is to serve as a reference and a starting point for  
anyone who is looking at creating a CI pipeline for their development  
environment in a container and depend on build tools similar but not limited to  
composer and npm etc.

Project Files
-------------

1. Build/build.sh - Reference build script. Modify this to suit your build  
   environment.
2. Build/Dockerfile - Reference container definition based on composer.  
   Modify this to suit your build environment.
3. Nginx/Dockerfile - Reference container definition for PHP projects.
4. Nginx/nginx.conf - Reference nginx site configuration for PHP projects.
5. Php/Dockerfile - Reference php-fpm container definition for PHP projects.
