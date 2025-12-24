from django.http import HttpRequest
from django.shortcuts import render

def index(request: HttpRequest):
    return render(request, 'index.html')

def resume(request: HttpRequest):
    return render(request, 'resume.html')

def projects(request: HttpRequest):
    return render(request, 'projects.html')

def about(request: HttpRequest):
    return render(request, 'about.html')

