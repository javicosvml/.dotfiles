# macOS Setup Guide for Zsh and Tmux

Este documento proporciona instrucciones completas para configurar y validar tu entorno de desarrollo en macOS.

## Sistema Operativo Verificado
- **macOS**: 14.x y posteriores (Sonoma+)
- **Shell**: Zsh 5.8+
- **Tmux**: 3.4+
- **Procesador**: Apple Silicon (arm64) y Intel (x86_64)

## Instalación Rápida

### 1. Verificar Homebrew
```bash
# Verificar instalación
which brew
brew --version

# Si no está instalado:
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

### 2. Instalar Herramientas Esenciales
```bash
# Herramientas core
brew install zsh tmux neovim git

# Herramientas complementarias recomendadas
brew install bat fd ripgrep fzf zoxide eza duf dust

# Soporte para lenguajes (opcional)
brew install asdf
asdf plugin add nodejs
asdf plugin add python
```

### 3. Instalar Gitstatus (Opcional - Para mejor rendimiento del prompt)
```bash
brew tap romkatv/powerlevel10k
# O instalarlo manualmente vía Zinit (ya configurado en plugins.zsh)
```

### 4. Configurar Tmux Plugin Manager (TPM)
```bash
# TPM ya debería estar clonado, pero si no:
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# Instalar plugins:
# En tmux, presiona: <prefix> + I (shift+i)
# O manualmente:
~/.tmux/plugins/tpm/bin/install_plugins
```

## Validación de Configuración

### Validar Zsh
```bash
# Verificar sintaxis
zsh -n ~/.zshrc
zsh -n ~/.zsh.d/*.zsh

# Verificar carga de plugins
zsh -i -c "zinit list"

# Verificar tiempo de inicio
time zsh -i -c exit
```

### Validar Tmux
```bash
# Verificar sintaxis
tmux source-file ~/.tmux.conf

# Dentro de tmux, recargar configuración
# <prefix> + r (reload config)

# Verificar que pbcopy/pbpaste funciona
echo "test" | pbcopy
pbpaste
```

## Características Principales

### Zsh Configuration
- **Modular**: Separado en archivos por funcionalidad
- **Rápido**: Usa Zinit con Turbo mode para carga diferida
- **Inteligente**: Auto-completa con colores, historial compartido
- **Compatible**: Fallbacks si faltan dependencias

#### Plugins Cargados
- `gitstatus`: Información de git ultra-rápida (fallback: vcs_info)
- `zsh-completions`: Auto-completa avanzada
- `zsh-autosuggestions`: Sugerencias basadas en historial
- `fast-syntax-highlighting`: Resaltado de sintaxis en tiempo real
- `history-search-multi-word`: Búsqueda avanzada de historial
- `fzf`: Búsqueda difusa (carga deferida)

### Tmux Configuration
- **TPM**: Gestor de plugins
- **Plugins instalados**:
  - `tmux-sensible`: Configuraciones sensibles por defecto
  - `tmux-resurrect`: Persistencia de sesiones
  - `tmux-continuum`: Auto-guardado de sesiones
  - `tmux-yank`: Mejor soporte de portapapeles
  - `vim-tmux-navigator`: Navegación integrada Vim/Neovim

### Funcionalidades macOS

#### Prompt Zsh Mejorado
```
~/projects/dotfiles (main ● ✓) ❯
```
- Ruta actual
- Rama git y cambios
- Indicador de estado (✓ éxito, ✗ error)
- Virtualenv/conda si está activo
- Contexto kubectl si está configurado

#### Copiar/Pegar en Tmux
- **Copy mode**: Presiona `Enter`, selecciona con `v`, copia con `y`
- **Mouse drag**: Arrastra para seleccionar y copiar automáticamente
- **Double-click**: Selecciona palabra completa
- **Triple-click**: Selecciona línea completa
- **Right-click**: Pega desde portapapeles

#### Navegación Tmux
- `<prefix>` = `Ctrl+b` (o `Ctrl+a` como alternativa)
- `<prefix> + h/j/k/l`: Navegar panes (vim-style)
- `<prefix> + c`: Crear nueva ventana
- `<prefix> + -`: Split vertical
- `<prefix> + _`: Split horizontal
- `<prefix> + d`: Desconectar de sesión
- `<prefix> + [`: Entrar en copy mode

## Troubleshooting

### Problema: Errores en el prompt
**Solución**: Verifica que gitstatus esté instalado o el fallback vcs_info funcionará automáticamente.

### Problema: Tmux no copia al portapapeles
**Solución**: Asegúrate de que pbcopy está disponible
```bash
which pbcopy  # Debería estar en /usr/bin/pbcopy
```

### Problema: Shell lenta al iniciar
**Solución**: Perfila la startup
```bash
# Perfil detallado
zsh -x -i -c exit 2>&1 | head -50

# Usando hyperfine (más preciso)
brew install hyperfine
hyperfine "zsh -i -c exit"
```

### Problema: Las teclas no funcionan correctamente
**Solución**: Verifica la configuración de repeat-time en tmux.conf (está configurada para 1000ms en macOS)

## Configuración Recomendada para Kitty

Si usas Kitty como terminal, también tienes:
- `alias ssh="kitty +kitten ssh"`
- `alias icat="kitty +kitten icat"` (ver imágenes en terminal)
- `alias d="kitty +kitten diff"` (diff con imágenes)

## Ambiente IDE

### Neovim
- Ubicación config: `~/.config/nvim/`
- Plugin manager: lazy.nvim (ya configurado)
- LSP: Preconfigurado para múltiples lenguajes

### Git
- Alias configurados automáticamente
- Integración git-flow ready
- Pre-commit hooks disponibles

## Mantenimiento

### Actualizar Plugins Zinit
```bash
zinit self-update
zinit update --parallel
```

### Actualizar Plugins Tmux
```bash
# En tmux
<prefix> + U (shift+u)
```

### Verificar que todo funciona
```bash
# Script de validación completa
exec zsh  # Recarga shell
tmux -V   # Verifica versión tmux
echo $ZSH_VERSION  # Verifica versión zsh
```

## Personalizaciones

Todas las configuraciones pueden editarse en archivos modulares:

- `~/.zshrc`: Configuración principal
- `~/.zsh.d/env.zsh`: Variables de entorno
- `~/.zsh.d/prompt.zsh`: Personalización del prompt
- `~/.zsh.d/alias.zsh`: Alias de comandos
- `~/.zsh.d/plugins.zsh`: Plugins y su carga

- `~/.tmux.conf`: Configuración principal de tmux
- `~/.tmux/plugins/`: Plugins de tmux

## Performance Tips

1. **Startup**: Está optimizado con lazy-loading. Tiempo típico: 100-200ms
2. **History**: 10,000 comandos (configurable en history.zsh)
3. **Completions**: Async para no bloquear
4. **Git Info**: Usa gitstatus si está disponible (10x más rápido que vcs_info)

## Soporte

Para debugging detallado, activa verbose mode:
```bash
# En zsh
exec zsh -x

# En tmux
tmux -v
```

---

Última actualización: 2025-12-11
