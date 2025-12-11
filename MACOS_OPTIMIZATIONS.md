# macOS Optimizations & Best Practices

Documentación completa de optimizaciones y mejores prácticas para tu configuración de Zsh y Tmux en macOS.

## 1. Optimizaciones de Zsh

### 1.1 Startup Performance

Tu configuración está optimizada para startup rápido:

- **Modular loading**: Cada aspecto cargado en archivo separado
- **Lazy loading con Zinit**: Plugins se cargan en background
- **Turbo mode**: Plugins no críticos se cargan después de mostrar el prompt
- **Tipícal startup time**: 150-250ms

Para medir:
```bash
# Medida simple
time zsh -i -c exit

# Medida detallada (identifica qué es lento)
zsh -x -i -c exit 2>&1 | grep -E "^\+" | head -50
```

### 1.2 Plugin Configuration Detalles

#### gitstatus (Git Fast)
- Si está disponible: ~10ms por consulta de git
- Si no está: Fallback a `vcs_info` (~200ms, pero funciona igual)
- **Instalación**: Automática vía Zinit en plugins.zsh

#### zsh-autosuggestions (Auto-complete)
- Configurado para:
  - Strategy: historial + completions
  - Async enabled para no bloquear
  - Buffer max 20 caracteres

#### fast-syntax-highlighting (Colores)
- Resaltado en tiempo real
- ~50x más rápido que zsh-syntax-highlighting
- Cargado último en cadena de completions

### 1.3 Configuraciones Críticas

#### Color System
- Sistema de colores de 256 colores
- Soporte RGB/Truecolor activado
- LSCOLORS optimizado para TokyoNight

#### History
- Archivo: `~/.zsh_history`
- Tamaño: 10,000 comandos
- Compartido entre sesiones
- No guarda comandos que comienzan con espacio

#### Completions
- Case-insensitive
- Menu interactivo con colores
- Rehash automático

## 2. Optimizaciones de Tmux

### 2.1 Performance Settings

```tmux.conf
set -s escape-time 10          # 10ms para mejor responsiveness
set -s focus-events on         # Eventos de foco para neovim
set -g repeat-time 1000        # 1s de repeat time (macOS friendly)
```

Estos valores están optimizados para macOS y evitan problemas comunes con key repeat.

### 2.2 Terminal Support

Tmux detecta automáticamente:
- `xterm-256color`: Soporte de color
- `xterm-kitty`: Soporte especial para Kitty terminal
- `tmux-256color`: Modo nativo tmux

### 2.3 Clipboard Integration

**macOS (Tu configuración)**:
```tmux.conf
bind y run-shell "tmux save-buffer - | pbcopy"
bind -T copy-mode-vi y send -X copy-pipe-and-cancel "pbcopy"
```

Características:
- Copia con `y` en copy-mode
- Mouse drag selecciona y copia
- Click derecho pega

### 2.4 Mouse Support

- Mouse enabled por defecto
- Scroll en copy-mode
- Click para seleccionar pane
- Drag para redimensionar panes

## 3. Integración Neovim

### 3.1 Navegación entre Neovim y Tmux

Con `vim-tmux-navigator` plugin:

```
Ctrl+h/j/k/l navega entre panes de neovim y tmux
```

El comando en tmux detecta si hay un neovim corriendo:
```bash
is_vim="ps -o state= -o comm= -t '#{pane_tty}' | grep -iqE '^[^TXZ ]+ +(\\S+\\/)?g?(view|n?vim?x?)(diff)?$'"
```

### 3.2 Session Persistence

Con `tmux-resurrect` y `tmux-continuum`:
- Auto-guarda sesión cada 15 minutos
- Restaura sesión al reiniciar tmux
- Preserva directorios y procesos

Teclas:
- `<prefix> + C-s`: Guardar sesión manualmente
- `<prefix> + C-r`: Restaurar sesión

## 4. Seguridad

### 4.1 Historia Segura

Comandos que **NO** se guardan:
- Comandos con espacios al inicio
- Comandos duplicados
- Contraseñas (si usas aliases como `export PASSWORD=...`)

### 4.2 Recomendaciones

```bash
# Para comandos sensibles, prefija con espacio
 export AWS_KEY=secreto  # No se guarda en history

# O desactiva history temporalmente
unset HISTFILE
comando-sensible
set HISTFILE=~/.zsh_history
```

## 5. Customización

### 5.1 Cambiar Colores del Prompt

En `~/.zsh.d/prompt.zsh`:
```zsh
# Cambiar código de color (0-255)
typeset -g PROMPT_COLOR_DIR=31        # Azul brillante
typeset -g PROMPT_COLOR_GIT_BRANCH=76 # Verde brillante

# O usar nombres
typeset -g PROMPT_COLOR_DIR="blue"
```

### 5.2 Cambiar Símbolos del Prompt

```zsh
typeset -g PROMPT_SYMBOL_ARROW="❯"    # Tu símbolo
typeset -g PROMPT_SYMBOL_SUCCESS="✓"  # Éxito
typeset -g PROMPT_SYMBOL_ERROR="✗"    # Error
typeset -g PROMPT_SYMBOL_GIT_STAGED="●" # Cambios staged
```

### 5.3 Desactivar Características

En `~/.zsh.d/prompt.zsh`:
```zsh
typeset -g PROMPT_SHOW_GIT=false           # No mostrar git
typeset -g PROMPT_SHOW_VIRTUALENV=false    # No mostrar virtualenv
typeset -g PROMPT_SHOW_KUBECTL=false       # No mostrar kubectl
```

### 5.4 Agregar Alias

En `~/.zsh.d/alias.zsh`:
```zsh
# Alias rápido
alias ll='/bin/ls -lGah'
alias gs='git status'
alias gp='git push'

# Función personalizada
mkcd() {
    mkdir -p "$1" && cd "$1"
}
```

## 6. Troubleshooting Avanzado

### 6.1 Debugging Zsh

```bash
# Modo verbose
zsh -x -i -c "your-command"

# Profiler
zmodload zsh/zprof
# ... comandos ...
zprof

# Cargar con debugging
exec zsh -x
```

### 6.2 Debugging Tmux

```bash
# Modo verbose
tmux -v

# Ver bindings
tmux list-keys

# Ver configuración actual
tmux show-options -g
tmux show-options -w
```

### 6.3 Problemas Comunes

#### Problema: Prompt muy lento
**Causa**: gitstatus no está instalado o hay repositorio git muy grande
**Solución**:
```bash
# Desactiva git en prompt
export PROMPT_SHOW_GIT=false
```

#### Problema: Tmux no ve la terminal correctamente
**Causa**: Variable TERM incorrecta
**Solución**:
```bash
# Verifica TERM actual
echo $TERM

# Si es "screen", hay problema
# En ~/.zshrc
export TERM=xterm-256color
```

#### Problema: Copy/paste no funciona en tmux
**Causa**: pbcopy no disponible o configuración incorrecta
**Solución**:
```bash
# Verifica pbcopy
which pbcopy

# Test manual
echo "test" | pbcopy
pbpaste
```

#### Problema: Plugins de Zinit no se cargan
**Causa**: Problema con permiso o ruta
**Solución**:
```bash
# Reinstalar Zinit
rm -rf ~/.local/share/zinit
# Próxima vez que abras terminal, se instalará automáticamente

# O hacer manualmente
mkdir -p ~/.local/share/zinit
git clone https://github.com/zdharma-continuum/zinit.git ~/.local/share/zinit/zinit.git
```

## 7. Monitoreo

### 7.1 Ver Procesos en Tmux

```bash
# Listar sesiones
tmux list-sessions

# Listar ventanas de sesión
tmux list-windows -t session-name

# Listar panes
tmux list-panes -t session-name:window-index
```

### 7.2 Espacio en Disco

```bash
# Tamaño de historial
du -h ~/.zsh_history

# Tamaño de plugins
du -sh ~/.local/share/zinit
du -sh ~/.tmux/plugins

# Limpiar
rm ~/.zsh_history  # Se recrea automáticamente
```

## 8. Actualizaciones

### 8.1 Actualizar Homebrew Packages

```bash
brew update
brew upgrade
brew cleanup
```

### 8.2 Actualizar Plugins Zsh

```bash
# Automático (dentro de zsh)
zinit self-update
zinit update --parallel
```

### 8.3 Actualizar Plugins Tmux

```bash
# Dentro de tmux
<prefix> + U  (shift+u)
```

## 9. Backup & Restore

### 9.1 Backup de Configuración

```bash
# Backup completo
tar -czf dotfiles-backup-$(date +%Y%m%d).tar.gz \
  ~/.zshrc \
  ~/.zsh.d \
  ~/.tmux.conf \
  ~/.tmux/plugins

# O simplemente
git -C ~/.dotfiles push
```

### 9.2 Restore de Sesiones Tmux

Las sesiones se guardan automáticamente con `tmux-continuum`:
```bash
# Si pierdes sesión
<prefix> + C-r  (restore)
```

## 10. Performance Benchmarking

### 10.1 Benchmark Startup

```bash
# Simple
for i in {1..5}; do
    time zsh -i -c exit
done

# Con hyperfine (más preciso)
brew install hyperfine
hyperfine "zsh -i -c exit" --runs 10
```

Valores típicos:
- **Sin plugins**: ~30ms
- **Con plugins (lazy loaded)**: ~150-250ms
- **Primera carga de plugins**: ~500ms (después se cachean)

### 10.2 Monitoreo de Recursos

```bash
# Ver memoria de zsh
ps aux | grep zsh | grep -v grep

# Ver procesos en tmux
tmux list-panes -a -F "#{pane_current_command}"
```

## 11. Integración con Otros Tools

### 11.1 Docker

```bash
# Alias disponible si docker está instalado
docker run --rm -ti ubuntu:latest bash
```

### 11.2 Kubernetes

Si kubectl está instalado:
- El prompt muestra el contexto actual
- Cachea la información (se actualiza cada 5s)

```bash
# Ver contexto
kubectl config current-context

# El prompt lo mostrará automáticamente
```

### 11.3 Python Virtualenv

```bash
# El prompt detalla el virtualenv activo
source venv/bin/activate
# Ahora muestra "(venv)" en el prompt
```

## 12. macOS-Specific Tips

### 12.1 Integración Finder

```bash
# Abrir Finder en directorio actual
alias o='open'
alias o.='open .'

# Actualizar Finder rápidamente
o .
```

### 12.2 Integración Spotlight

```bash
# Algunos comandos no índexan de la misma forma
# En ~/.zsh.d/alias.zsh se configura según necesidad
```

### 12.3 Notificaciones

```bash
# macOS notifications (si necesitas)
# Puedes enviar con AppleScript
osascript -e 'display notification "Mensaje" with title "Título"'
```

---

**Última actualización**: 2025-12-11
**Versión**: 1.0
**Compatible con**: macOS 13+, Apple Silicon & Intel
