from django.shortcuts import render, redirect
from django.contrib.auth import login

from ..forms import RegistroUsuarioForm


def registro_view(request):
    if request.method == 'POST':
        form = RegistroUsuarioForm(request.POST)
        if form.is_valid():
            user = form.save()
            login(request, user)
            if user.rol == 'empresa': return redirect('dashboard_empresa')
            return redirect('dashboard_desarrollador')
    else:
        form = RegistroUsuarioForm()
    return render(request, 'publico/registro.html', {'form': form})
