from django_components import Component, register

@register("wip_banner")
class Footer(Component):
    template_file = "wip_banner.html"

