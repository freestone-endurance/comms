---
layout: manual-wrapper
---
{% capture title %}
# {{ page.title }}
{% endcapture %}
{{ title | markdownify }}

{% capture intro_content %}{% include parts/intros/{{page.race}}.markdown %}{% endcapture %}
{{ intro_content | markdownify }}

{{content}}

{% for part in page.parts %}

{% capture part_content %}{% include parts/{{part}}.markdown %}{% endcapture %}
{{ part_content | markdownify }}

{% endfor %}

