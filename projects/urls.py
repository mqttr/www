from django.urls import path, include
from django.views.generic import TemplateView

from projects import views

app_name = "projects"
urlpatterns = [
    path('', TemplateView.as_view(template_name='projects/index.html'), name='index'),
    path('cs2_grading', TemplateView.as_view(template_name='projects/projects/cs2_grading.html'), name='cs2_grading'),
    path('homelab', TemplateView.as_view(template_name='projects/projects/homelab.html'), name='homelab'),
    path('installation_troubleshooting', TemplateView.as_view(template_name='projects/projects/installation_troubleshooting.html'), name='installation_troubleshooting'),
    path('website', TemplateView.as_view(template_name='projects/projects/mainsite.html'), name='mainsite'),
]

