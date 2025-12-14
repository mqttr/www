from django_components import Component, register

@register("header")
class Footer(Component):
    template_file = "header.html"

