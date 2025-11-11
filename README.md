# Dotfiles para macOS

Configuración completa de entorno de desarrollo para macOS con ZSH, Tmux, Neovim y Kitty.

## 📋 Tabla de Contenidos

- [Instalación Rápida](#-instalación-rápida)
- [Componentes](#-componentes)
- [Estructura del Repositorio](#-estructura-del-repositorio)
- [Comandos Principales](#-comandos-principales)
- [Configuración Detallada](#-configuración-detallada)
- [Herramientas Instaladas](#️-herramientas-instaladas)
- [Personalización](#-personalización)
- [Solución de Problemas](#-solución-de-problemas)
- [Mantenimiento](#-mantenimiento)
- [Changelog](#-changelog)
- [Scripts de Utilidad](#-scripts-de-utilidad)

---

## 🚀 Instalación Rápida

### Requisitos Previos
- macOS Ventura 13.0 o posterior
- Xcode Command Line Tools

```bash
# Instalar Xcode Command Line Tools
xcode-select --install
```

### Instalación Completa

```bash
# 1. Clonar repositorio
git clone <tu-repo-url> ~/.dotfiles
cd ~/.dotfiles

# 2. Instalar prerequisites (Homebrew, herramientas básicas)
./scripts/macos-setup

# 3. Instalar ASDF (gestor de versiones)
make asdf
source ~/.zshrc

# 4. Instalar configuraciones de shell y editor
make profile

# 5. Instalar herramientas de desarrollo
make tools

# 6. (Opcional) Instalar Kitty terminal
make kitty

# 7. Reiniciar terminal
source ~/.zshrc
```

### Verificar Instalación

```bash
./scripts/verify-setup
```

---

## 🎯 Componentes

### Shell (ZSH)
- **Plugin Manager**: Zinit
- **Theme**: Powerlevel10k
- **Features**:
  - Syntax highlighting
  - Autosuggestions
  - FZF integration
  - Kubernetes context
  - Historia optimizada

### Editor (Neovim/Vim)
- **Plugin Manager**: vim-plug
- **Plugins**:
  - NerdTree (explorador de archivos)
  - FZF (búsqueda fuzzy)
  - Lightline (barra de estado)
  - Auto-formato para múltiples lenguajes

### Terminal Multiplexer (Tmux)
- Configuración basada en gpakosz/.tmux
- Auto-inicio con ZSH
- Barra de estado personalizada
- Mouse support

### Terminal (Kitty)
- Tema Nord-inspired
- Background blur con 95% opacity
- JetBrains Mono font con ligatures
- Integración con tmux optimizada
- Atajos de teclado estilo macOS

### Gestor de Versiones (ASDF)
- Instalado vía Homebrew (siempre última versión)
- Gestión de versiones de:
  - Python, Node.js, Go, Rust, Ruby
  - Terraform
  - Kubernetes tools
  - Cloud CLIs

---

## 📁 Estructura del Repositorio

```
~/.dotfiles/
├── README.md                 # Este archivo
├── Makefile                  # Instalador principal
├── config/
│   └── kitty/
│       └── kitty.conf       # Configuración de Kitty
├── profile/
│   ├── Makefile             # Instalador de perfiles
│   ├── zshrc                # Configuración ZSH
│   ├── zsh.d/
│   │   ├── alias.zsh        # Aliases personalizados
│   │   └── tools.zsh        # Configuración de herramientas
│   ├── vimrc                # Configuración Neovim/Vim
│   ├── tmux.conf            # Configuración base de Tmux
│   └── tmux.local           # Personalización de Tmux
├── tools/
│   └── Makefile             # Instalador de herramientas
└── scripts/
    ├── macos-setup          # Setup inicial de macOS
    ├── verify-setup         # Verificación de instalación
    ├── dclean               # Limpieza de Docker
    ├── kleanup              # Limpieza de Kubernetes
    ├── passwdgen            # Generador de contraseñas
    └── web-analizer         # Analizador de infraestructura web
```

---

## ⚡ Comandos Principales

### Makefile Principal (raíz)

```bash
make help           # Mostrar ayuda
make all            # Instalar todo (brew + profile + tools + kitty)
make brew           # Instalar/verificar Homebrew
make asdf           # Instalar/actualizar ASDF
make profile        # Instalar configuraciones de shell/editor
make tools          # Instalar herramientas de desarrollo
make kitty          # Instalar y configurar Kitty
make clean          # Limpiar symlinks y archivos temporales
```

### Herramientas de Desarrollo (tools/)

```bash
cd tools

# Instalación
make all            # Python, Node.js, Terraform, Kubernetes (no interactivo)
make all-tools      # Instalación interactiva (pregunta qué instalar)
make brew-tools     # Herramientas CLI vía Homebrew

# Lenguajes
make python         # Python (última versión estable)
make nodejs         # Node.js (última LTS)
make golang         # Go (última versión)
make rust           # Rust (última versión)
make ruby           # Ruby (última versión)

# DevOps
make terraform      # Terraform
make kubernetes     # kubectl, helm, kind, kubectx, krew
make docker         # Docker Desktop

# Cloud
make aws            # AWS CLI
make gcloud         # Google Cloud SDK
make azure          # Azure CLI

# Gestión
make list           # Listar herramientas instaladas
make update         # Actualizar plugins de ASDF
```

---

## 🔧 Configuración Detallada

### ZSH

**Ubicación**: `~/.dotfiles/profile/zshrc`

**Features**:
- Auto-inicio de tmux (sesión "main")
- Powerlevel10k instant prompt
- 10,000 líneas de historia
- Completion mejorado
- Integración con Homebrew (Apple Silicon + Intel)

**Aliases principales**:
```bash
# Modern CLI tools (si están instalados)
cat → bat           # Syntax highlighting
ls → lsd            # Con iconos y colores

# Git
g, ga, gc, gp, gl, gst, gd, gco, gb, glog

# Docker/Kubernetes (si disponibles)
k → kubectl
kgp, kgs, kgd, kdp, kl, klf

# macOS específicos
showfiles/hidefiles # Mostrar/ocultar archivos en Finder
flushdns           # Limpiar caché DNS
afk                # Bloquear pantalla
```

**Personalizar**: Editar `~/.dotfiles/profile/zsh.d/alias.zsh`

### Neovim/Vim

**Ubicación**: `~/.dotfiles/profile/vimrc`

**Atajos principales**:
```vim
<Space>      " Leader key
<Leader>n    " Focus NerdTree
<C-n>        " Abrir NerdTree
<C-t>        " Toggle NerdTree
<C-f>        " Buscar archivo actual en NerdTree
<C-p>        " FZF buscar archivos
<Leader>b    " FZF buffers
<Leader>f    " FZF ripgrep
<Esc>        " Limpiar highlighting de búsqueda
```

**Primera vez**:
```bash
# Instalar plugins
nvim +PlugInstall +qall

# Actualizar plugins
nvim +PlugUpdate +qall
```

### Tmux

**Ubicación**: `~/.dotfiles/profile/tmux.conf` y `tmux.local`

**Características**:
- Auto-inicio con ZSH
- Prefix: `Ctrl+B` y `Ctrl+A` (GNU-Screen compatible)
- Mouse support
- Barra de estado personalizada con emoji

**Atajos principales**:
```bash
# Gestión de sesiones
tmux                    # Nueva sesión
tmux new-session -A -s main  # Crear/adjuntar a "main"
tmux ls                 # Listar sesiones
tmux attach -t main     # Adjuntar a sesión
tmux kill-server        # Matar todas las sesiones

# Dentro de tmux (Prefix = Ctrl+B)
Prefix + c              # Nueva ventana
Prefix + n/p            # Siguiente/anterior ventana
Prefix + -              # Split horizontal
Prefix + _              # Split vertical
Prefix + h/j/k/l        # Navegar paneles
Prefix + [              # Modo copia
Prefix + r              # Recargar configuración
```

**Personalizar**: Editar `~/.tmux.conf.local` (no modificar `.tmux.conf`)

### Kitty

**Ubicación**: `~/.dotfiles/config/kitty/kitty.conf`

**Características**:
- Tema Nord-inspired
- 95% opacity con blur
- JetBrains Mono font (13pt)
- Shell integration optimizada para tmux
- True color support

**Atajos principales**:
```bash
Cmd+T               # Nueva pestaña
Cmd+W               # Cerrar pestaña
Cmd+N               # Nueva ventana OS
Cmd+Enter           # Nueva ventana (split)
Cmd+1-9             # Cambiar a pestaña 1-9
Cmd+Shift+[/]       # Navegar pestañas
Cmd+,               # Editar configuración
Cmd+Shift+,         # Recargar configuración
Cmd+K               # Limpiar scrollback
Cmd+=/–             # Aumentar/disminuir tamaño
Cmd+0               # Reset tamaño de fuente
```

**Recargar configuración**:
```bash
# En Kitty
Cmd+Shift+,

# O manualmente
kill -SIGUSR1 $(pgrep kitty)
```

### ASDF

**Gestión de versiones**:

```bash
# Ver versiones instaladas
asdf current

# Listar versiones disponibles
asdf list all python
asdf list all nodejs

# Instalar versión específica
asdf install python 3.11.5
asdf install nodejs 20.10.0

# Establecer versión global
asdf global python 3.11.5

# Establecer versión local (proyecto)
cd mi-proyecto
asdf local nodejs 20.10.0  # Crea .tool-versions

# Actualizar plugins
asdf plugin update --all

# Actualizar ASDF
cd ~/.dotfiles
make asdf
```

---

## 🛠️ Herramientas Instaladas

### CLI Modernas (vía Homebrew)
- **bat** - Better cat con syntax highlighting
- **lsd/exa** - Better ls con iconos
- **fd** - Better find
- **ripgrep (rg)** - Better grep
- **fzf** - Fuzzy finder
- **htop/btop** - Better top
- **dust** - Better du
- **duf** - Better df
- **procs** - Better ps
- **tree** - Visualizador de árbol de directorios
- **tldr** - Man pages simplificados
- **jq/yq** - Procesadores JSON/YAML
- **gh** - GitHub CLI
- **git-lfs** - Git Large File Storage

### Lenguajes (vía ASDF)
- Python (última estable)
- Node.js (última LTS: 18/20/22)
- Go (última versión)
- Rust (última versión)
- Ruby (última versión)

### DevOps (vía ASDF)
- Terraform
- kubectl
- helm
- kind (Kubernetes in Docker)
- kubectx/kubens
- krew (kubectl plugin manager)

### Cloud CLIs
- AWS CLI (vía ASDF)
- Google Cloud SDK (vía Homebrew)
- Azure CLI (vía Homebrew)

---

## 🎨 Personalización

### Añadir Aliases ZSH

Editar `~/.dotfiles/profile/zsh.d/alias.zsh`:

```bash
# Añadir al final
alias myalias='my command'
```

### Añadir Funciones ZSH

Editar `~/.dotfiles/profile/zsh.d/tools.zsh`:

```bash
# Añadir al final
my_function() {
    echo "Mi función"
}
```

### Configurar Powerlevel10k

```bash
p10k configure
```

### Cambiar Tema de Kitty

Editar `~/.dotfiles/config/kitty/kitty.conf`:

```conf
# Buscar sección "Color Scheme"
# Cambiar colores según preferencia
```

Temas disponibles:
- https://github.com/dexpota/kitty-themes
- https://github.com/kdrag0n/base16-kitty

### Cambiar Font

Editar `~/.dotfiles/config/kitty/kitty.conf`:

```conf
font_family      Tu Font Preferida
font_size        14.0
```

Fonts recomendadas:
- JetBrains Mono (actual)
- Fira Code
- Hack Nerd Font
- SF Mono
- Source Code Pro

---

## 🐛 Solución de Problemas

### Tmux no se inicia automáticamente en Kitty

**Problema**: Al abrir Kitty no se inicia tmux o se queda colgado.

**Solución**:
```bash
# 1. Matar sesiones existentes
tmux kill-server

# 2. Cerrar completamente Kitty (Cmd+Q)

# 3. Abrir Kitty de nuevo

# 4. Verificar
echo "TMUX: $TMUX"  # Debe tener valor
echo "TERM: $TERM"  # Debe ser screen-256color dentro de tmux
```

**Causa**: Conflicto entre shell_integration de Kitty y tmux. Ya corregido en configuración actual (shell_integration configurado como `no-cursor`).

### Powerlevel10k no se muestra correctamente

**Problema**: El theme no carga o se ve mal.

**Solución**:
```bash
# 1. Verificar que existe configuración
ls -la ~/.p10k.zsh

# 2. Reconfigurar
p10k configure

# 3. Verificar que Zinit está instalado
ls -la ~/.local/share/zinit/zinit.git

# 4. Si falta, reinstalar
rm -rf ~/.local/share/zinit
source ~/.zshrc
```

### ASDF no encuentra comandos

**Problema**: Después de instalar herramientas con ASDF, no se encuentran.

**Solución**:
```bash
# 1. Verificar ASDF está en PATH
which asdf

# 2. Si no está, reinstalar
cd ~/.dotfiles
make asdf
source ~/.zshrc

# 3. Verificar herramientas instaladas
asdf current

# 4. Reinstalar herramienta si necesario
cd ~/.dotfiles/tools
make python  # o la herramienta que necesites
```

### Neovim plugins no se instalan

**Problema**: Al abrir Neovim no se ven los plugins.

**Solución**:
```bash
# Instalar/actualizar plugins
nvim +PlugInstall +PlugUpdate +qall

# Si hay errores, limpiar y reinstalar
rm -rf ~/.vim/plugged
rm -rf ~/.local/share/nvim/site/autoload/plug.vim
nvim +PlugInstall +qall
```

### Homebrew no se encuentra

**Problema**: `brew: command not found`

**Solución**:
```bash
# Apple Silicon
eval "$(/opt/homebrew/bin/brew shellenv)"

# Intel Mac
eval "$(/usr/local/bin/brew shellenv)"

# O reinstalar
cd ~/.dotfiles
make brew
source ~/.zshrc
```

### Colores no se ven bien

**Problema**: Los colores se ven mal en terminal.

**Solución**:
```bash
# 1. Verificar TERM
echo $TERM
# Debe ser: xterm-kitty (en Kitty) o screen-256color (en tmux)

# 2. Verificar COLORTERM
echo $COLORTERM
# Debe ser: truecolor

# 3. Reiniciar terminal completamente
```

### ZSH lento al iniciar

**Problema**: Terminal tarda mucho en abrir.

**Solución**:
```bash
# 1. Profiling
zsh -xv 2>&1 | tee /tmp/zsh-startup.log

# 2. Revisar log y deshabilitar plugins pesados en zshrc

# 3. Limpiar compdump
rm ~/.zcompdump*
compinit
```

---

## 🔄 Mantenimiento

### Actualizar Todo

```bash
cd ~/.dotfiles

# Actualizar dotfiles
git pull

# Actualizar Homebrew
brew update
brew upgrade
brew cleanup

# Actualizar ASDF
make asdf

# Actualizar plugins de ASDF
cd tools
make update

# Actualizar herramientas
make python nodejs terraform kubernetes

# Actualizar plugins de Zinit
zinit update

# Actualizar plugins de Neovim
nvim +PlugUpdate +qall
```

### Hacer Backup

```bash
# Backup de configuraciones actuales
cd ~
tar -czf dotfiles-backup-$(date +%Y%m%d).tar.gz \
    .zshrc .zsh.d .vimrc .tmux.conf .tmux.conf.local \
    .config/nvim .config/kitty .p10k.zsh

# Backup de versiones de ASDF
asdf current > ~/asdf-versions-$(date +%Y%m%d).txt
```

### Sincronizar en Nuevo Mac

```bash
# En el Mac nuevo
git clone <tu-repo-url> ~/.dotfiles
cd ~/.dotfiles

# Instalación completa
./scripts/macos-setup
make asdf
make profile
make tools
make kitty

# Restaurar configuración de Powerlevel10k (si la guardaste)
cp ~/backup/.p10k.zsh ~/.p10k.zsh

# Reiniciar terminal
source ~/.zshrc
```

---

## 📝 Changelog

### 2025-11-11 - ASDF v0.18.0 Compatibility Update

#### Mejorado
- **ASDF v0.18.0 Full Compatibility**: Todos los Makefiles optimizados para ASDF v0.18.0+
- **Error Handling**: Mejor manejo de errores y códigos de salida en instalaciones
- **Version Detection**: Detección automática de versión de ASDF y validación de compatibilidad
- **Logging**: Logs de instalación guardados en `/tmp/` para debugging
- **Reshim Support**: Nuevo comando `make reshim` para actualizar shims después de instalaciones manuales
- **Plugin URLs**: URLs explícitas para plugins de Kubernetes (kind, kubectx, krew)
- **Version Filtering**: Mejores filtros para seleccionar versiones estables (sin pre-releases)

#### Añadido
- Verificación de versión mínima de ASDF (v0.18.0+) en `check-asdf`
- Comandos `asdf reshim` después de cada instalación
- Output mejorado con códigos de color y progreso detallado
- Nuevo target `reshim` en tools/Makefile para reshimming manual
- Actualización de ASDF incluida en `make update`
- Script `macos-setup` mejorado con mejor feedback y colores

#### Corregido
- Compatibilidad con `asdf list` que ahora retorna código 0 sin versiones
- Manejo correcto de plugins que requieren URLs explícitas
- Filtrado de versiones para evitar pre-releases y betas
- Supresión de mensajes "already installed" duplicados
- Mejor detección de errores en instalaciones fallidas

#### Técnico
- `asdf plugin add` ahora con URLs explícitas donde necesario
- `asdf reshim` ejecutado después de cada `global`
- `2>/dev/null` agregado a comandos que pueden fallar silenciosamente
- Mejor uso de exit codes y validaciones
- Logs de instalación redirigidos a archivos temporales

### 2025-11-11 - Major Update

#### Cambiado
- **ASDF Version Management**: Cambiado de instalación manual a Homebrew
- Simplificada configuración de ASDF en `.zshrc`
- ASDF se actualiza automáticamente vía `brew upgrade asdf`
- **Documentación consolidada**: Todos los archivos markdown consolidados en README único

#### Añadido
- **Tools Makefile**: Automatización completa de instalación de herramientas
- Soporte para Python, Node.js, Go, Rust, Ruby
- Terraform y Kubernetes tools (kubectl, helm, kind, kubectx, krew)
- Cloud CLIs (AWS, GCloud, Azure)
- Modern CLI tools (bat, lsd, fd, ripgrep, fzf, etc.)
- Modo interactivo para seleccionar herramientas
- Makefile mejorado con targets individuales

#### Mejorado
- Documentación consolidada en README único
- Mejor manejo de errores en scripts
- Mensajes de ayuda más claros
- Instalación más rápida y confiable

#### Corregido
- **Kitty + Tmux integration**: Deshabilitado shell_integration que causaba conflictos
- **Auto-inicio de tmux**: Mejorada detección de shell interactivo
- **Powerlevel10k**: Eliminada carga redundante de shell_integration
- TERM variable correcta para Kitty (`xterm-kitty`)

### Breaking Changes
- ASDF ahora es gestionado por Homebrew (no git)
- Si tenías ASDF manual en `~/.asdf`, necesitas:
  1. Hacer backup: `asdf current > ~/asdf-versions-backup.txt`
  2. Eliminar: `rm -rf ~/.asdf`
  3. Reinstalar: `make asdf`
  4. Reinstalar herramientas: `cd tools && make all`

---

## 🆘 Scripts de Utilidad

### Verificar Instalación
```bash
./scripts/verify-setup
```
Verifica el estado de instalación de todos los componentes.

### Limpiar Docker
```bash
./scripts/dclean
```
Elimina contenedores detenidos, imágenes sin usar y volúmenes huérfanos.

### Limpiar Kubernetes
```bash
./scripts/kleanup
```
Limpia ReplicaSets antiguos, Jobs completados y Pods evicted.

### Generar Contraseña
```bash
./scripts/passwdgen
```
Genera contraseñas aleatorias seguras.

### Analizar Sitio Web
```bash
./scripts/web-analizer example.com
```
Analiza la infraestructura y configuración de un sitio web.

---

## 📚 Recursos

### Documentación Oficial
- [ASDF Documentation](https://asdf-vm.com/)
- [Zinit Documentation](https://github.com/zdharma-continuum/zinit)
- [Powerlevel10k](https://github.com/romkatv/powerlevel10k)
- [Neovim Documentation](https://neovim.io/doc/)
- [Tmux Documentation](https://github.com/tmux/tmux)
- [gpakosz/.tmux](https://github.com/gpakosz/.tmux)
- [Kitty Documentation](https://sw.kovidgoyal.net/kitty/)

### Compatibilidad
- ✅ macOS Ventura (13.x) y posterior
- ✅ Apple Silicon (M1/M2/M3) e Intel Macs
- ✅ Herramientas nativas de macOS con fallback a GNU coreutils
- ✅ Gestión de paquetes vía Homebrew

---

## 🆘 Soporte

### Para Problemas o Preguntas

1. Revisar esta documentación completa
2. Ejecutar `./scripts/verify-setup` para diagnóstico
3. Revisar sección de [Solución de Problemas](#-solución-de-problemas)
4. Revisar logs en `/tmp/`
5. Ejecutar `make help` en cualquier directorio para ver comandos disponibles
6. Abrir issue en el repositorio si el problema persiste

---

## 📄 Licencia

Este repositorio contiene configuraciones personales. Úsalo libremente y adáptalo a tus necesidades.

---

**¿Problemas?** Ejecuta `./scripts/verify-setup` para diagnosticar.

**¿Ayuda?** Ejecuta `make help` en cualquier directorio.

**¡Disfruta tu entorno de desarrollo! 🚀**
