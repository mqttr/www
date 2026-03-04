from django_components import Component, register

@register("wip")
class Footer(Component):
    template_file = "wip-banner.html"

