# 🚀 Quick Start - macOS Zsh & Tmux

¡Tu configuración está completa y optimizada para macOS! Aquí está todo lo que necesitas saber.

## ⚡ En 2 minutos

### 1. Recargar la terminal
```bash
exec zsh
```

### 2. Validar que funciona
```bash
~/.dotfiles/scripts/validate-setup.sh
```

✅ ¡Listo! Ya funciona.

---

## 📋 Funcionalidades Clave

### Terminal (Zsh)

#### Prompt Inteligente
```
~/projects/myapp (main ● ✓) ❯
```
- 🔵 Directorio actual (azul)
- 🟢 Rama git y cambios (verde si todo limpio, rojo si hay cambios)
- ✅ Indicador de último comando (✓ éxito, ✗ error)

#### Auto-completado
- Presiona `TAB` para completar
- `TAB` + `TAB` para ver opciones
- Coloreadas automáticamente

#### Historial Inteligente
- `Ctrl+R`: Buscar en historial
- Las sugerencias aparecen automáticamente
- Compartido entre ventanas

### Tmux (Multiplexor)

#### Navegación Básica
```
<prefix> = Ctrl+b (o Ctrl+a)

<prefix> + c        → Nueva ventana
<prefix> + n/p      → Siguiente/anterior ventana
<prefix> + [1-9]    → Ir a ventana 1-9
<prefix> + -        → Split vertical
<prefix> + _        → Split horizontal
<prefix> + h/j/k/l  → Navegar panes (como vim)
<prefix> + d        → Desconectar sesión
```

#### Copy-Paste
```
<prefix> + Enter    → Entrar en copy mode
v                   → Comenzar selección
y                   → Copiar al portapapeles
<prefix> + ]        → Pegar

O simplemente:
Arrastra mouse      → Copia automáticamente
Click derecho       → Pega
```

#### Sesiones
```
tmux new-session -s proyecto    → Crear sesión
tmux attach -t proyecto         → Conectar a sesión
tmux kill-session -t proyecto   → Eliminar sesión
tmux list-sessions              → Listar todas
```

---

## 🔗 Integración Vim/Neovim

Si estás en Neovim dentro de tmux:
```
Ctrl+h/j/k/l  → Navega entre splits sin problemas
```

La navegación es fluida entre neovim y tmux.

---

## 🎨 Personalización Rápida

### Cambiar colores del prompt
Edita: `~/.zsh.d/prompt.zsh`

```bash
typeset -g PROMPT_COLOR_DIR=31          # Color del directorio
typeset -g PROMPT_COLOR_GIT_BRANCH=76   # Color de la rama
```

### Cambiar símbolos
```bash
typeset -g PROMPT_SYMBOL_ARROW="❯"     # Tu símbolo preferido
typeset -g PROMPT_SYMBOL_SUCCESS="✓"
typeset -g PROMPT_SYMBOL_ERROR="✗"
```

### Desactivar git info (si va lento)
```bash
typeset -g PROMPT_SHOW_GIT=false
```

---

## 🐛 Problemas Comunes

### "Comando no encontrado"
Recarga el shell:
```bash
exec zsh
```

### "Tmux no copia al portapapeles"
Verifica que pbcopy funciona:
```bash
echo "test" | pbcopy
pbpaste  # Debería mostrar "test"
```

### "El prompt va muy lento"
```bash
# Desactiva git info temporalmente
export PROMPT_SHOW_GIT=false

# O instala gitstatus para más rápido
zinit light romkatv/gitstatus
```

### "Las teclas en tmux no funcionan"
Algunos terminales necesitan configuración especial. Si usas Kitty (recomendado):
```bash
# Ya debería funcionar. Si no:
export TERM=xterm-kitty
exec zsh
```

---

## 📚 Documentación Completa

Tienes 3 documentos completos:

1. **SETUP_MACOS.md** → Guía de instalación y validación
2. **MACOS_OPTIMIZATIONS.md** → Optimizaciones avanzadas
3. **CHANGES_SUMMARY.md** → Qué cambió en esta revisión

---

## 🚀 Comandos Útiles

```bash
# Recargar configuración
exec zsh                           # Zsh
tmux source-file ~/.tmux.conf      # Tmux en sesión activa

# Limpiar historial (si es necesario)
rm ~/.zsh_history
history -c

# Ver qué plugins están cargados
zinit list

# Actualizar plugins
zinit update --parallel
~/.tmux/plugins/tpm/bin/update_plugins

# Ver logs de sesión
tmux capture-pane -p -S -30
```

---

## 🎯 Lo Próximo

1. ✅ Tienes todo configurado
2. 📖 Lee SETUP_MACOS.md si necesitas ayuda
3. 🔧 Personaliza colores/símbolos si lo deseas
4. 🚀 ¡Disfruta tu terminal!

---

## 💡 Pro Tips

- Presiona `<prefix> + ?` en tmux para ver todos los keybindings
- Usa `zsh -i -c exit` para medir velocidad de startup
- `history | grep comando` para buscar comandos rápidamente
- Crea alias en `~/.zsh.d/alias.zsh` para comandos que usas frecuentemente

---

**¿Necesitas ayuda?** Revisa la sección de Troubleshooting en SETUP_MACOS.md

**Última actualización**: 2025-12-11
