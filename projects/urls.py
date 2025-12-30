from django.urls import path
from django.views.generic import TemplateView

from projects import views

app_name = "projects"
urlpatterns = [
    path('', TemplateView.as_view(template_name='projects/index.html'), name='index'),
    path('cs2-grading', TemplateView.as_view(template_name='projects/projects/cs2-grading.html'), name='cs2-grading'),
    path('homelab', TemplateView.as_view(template_name='projects/projects/homelab.html'), name='homelab'),
    path('installation-troubleshooting', TemplateView.as_view(template_name='projects/projects/installation-troubleshooting.html'), name='installation-troubleshooting'),
    path('mainsite', TemplateView.as_view(template_name='projects/projects/mainsite.html'), name='mainsite'),
]

