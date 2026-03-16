from django import forms
from django.contrib.auth.forms import UserCreationForm
from .models import Usuario, PerfilEmpresa, PerfilDesarrollador
from datetime import date

class RegistroUsuarioForm(UserCreationForm):
    email = forms.EmailField(required=True)
    fecha_nacimiento = forms.DateField(
        required=True,
        widget=forms.DateInput(attrs={'type': 'date', 'class': 'form-control'}),
        label="Fecha de Nacimiento"
    )
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
        fields = ('username', 'email', 'fecha_nacimiento', 'rol')
    
    def clean_fecha_nacimiento(self):
        fecha = self.cleaned_data.get('fecha_nacimiento')
        if fecha:
            today = date.today()
            edad = today.year - fecha.year - ((today.month, today.day) < (fecha.month, fecha.day))
            if edad < 18:
                raise forms.ValidationError("Debes ser mayor de edad (18 años) para registrarte en la plataforma.")
        return fecha

    def save(self, commit=True):
        user = super().save(commit=False)
        user.email = self.cleaned_data['email']
        user.rol = self.cleaned_data['rol']
        user.fecha_nacimiento = self.cleaned_data['fecha_nacimiento']
        
        if commit:
            user.save()
            
            # Crear perfil según el rol seleccionado
            if user.rol == 'empresa':
                PerfilEmpresa.objects.get_or_create(usuario=user)
            elif user.rol == 'desarrollador':
                PerfilDesarrollador.objects.get_or_create(usuario=user)
        
        return user

class PerfilEmpresaForm(forms.ModelForm):
    class Meta:
        model = PerfilEmpresa
        fields = ['nombre_empresa', 'nit', 'sector', 'telefono', 'ciudad', 'descripcion']
        widgets = {
            'nombre_empresa': forms.TextInput(attrs={'class': 'form-control', 'placeholder': 'Nombre de la empresa'}),
            'nit': forms.TextInput(attrs={'class': 'form-control', 'placeholder': 'NIT'}),
            'sector': forms.TextInput(attrs={'class': 'form-control', 'placeholder': 'Sector (ej: Tecnología)'}),
            'telefono': forms.TextInput(attrs={'class': 'form-control', 'placeholder': 'Teléfono'}),
            'ciudad': forms.TextInput(attrs={'class': 'form-control', 'placeholder': 'Ciudad'}),
            'descripcion': forms.Textarea(attrs={'class': 'form-control', 'rows': 4, 'placeholder': 'Breve descripción...'}),
        }

class PerfilDesarrolladorForm(forms.ModelForm):
    class Meta:
        model = PerfilDesarrollador
        fields = ['programa_formacion', 'ficha', 'habilidades']
        widgets = {
            'programa_formacion': forms.TextInput(attrs={'class': 'form-control', 'placeholder': 'Programa de formación (ADSO, etc)'}),
            'ficha': forms.TextInput(attrs={'class': 'form-control', 'placeholder': 'Número de Ficha'}),
            'habilidades': forms.Textarea(attrs={'class': 'form-control', 'rows': 4, 'placeholder': 'Lista tus habilidades (ej: Python, Java, SQL...)'}),
        }
