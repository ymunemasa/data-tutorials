---
title: HDP Readme
---

# HDP Tutorials
_(latest version: HDP 2.5)_

{% assign readme_path = "_tutorials/hdp" }

{% comment %}
<!--
{{ page.path }}
{% assign readme_path = page.path | split: '/' | reverse | shift | reverse | join: '/' | append: '/' %}
PATH: {{ readme_path }}
-->
{% endcomment %}

{% for tutorial in site.tutorials %}
  {% if tutorial.path contains readme_path %}
-   [{{ tutorial.title }}]({{ tutorial.path | remove: readme_path }})
    {% if tutorial.tags.size > 0 %}Tags: [{{ tutorial.tags | join: ', ' }}]{% endif %}
  {% endif %}
{% endfor %}
