from django import forms
from django.contrib.auth.forms import UserCreationForm
from .models import Usuario, PerfilEmpresa, PerfilDesarrollador

class RegistroUsuarioForm(UserCreationForm):
    email = forms.EmailField(required=True)
    rol = forms.ChoiceField(
        choices=[
            ('desarrollador', 'Desarrollador'),
            ('empresa', 'Empresa'),
            ('administrador', 'Administrador'),
        ],
        required=True
    )
    
    class Meta:
        model = Usuario
        fields = ('username', 'email', 'rol', 'password1', 'password2')
    
    def save(self, commit=True):
        user = super().save(commit=False)
        user.email = self.cleaned_data['email']
        user.rol = self.cleaned_data['rol']
        
        if commit:
            user.save()
            
            # Crear perfil según el rol seleccionado
            if user.rol == 'empresa':
                PerfilEmpresa.objects.create(usuario=user)
            elif user.rol == 'desarrollador':
                PerfilDesarrollador.objects.create(usuario=user)
            # Los administradores no tienen perfil extra
        
        return user