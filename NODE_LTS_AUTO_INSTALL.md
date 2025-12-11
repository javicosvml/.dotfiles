# Node.js LTS Auto-Install Configuration

Documentación sobre cómo la configuración automática instala la última versión LTS de Node.js.

## ¿Por qué LTS?

Node.js sigue un ciclo de liberación específico:
- **Versiones pares (20, 22, 24, 26)**: Son versiones LTS (Long Term Support)
- **Versiones impares (21, 23, 25)**: Son versiones Current (corta duración)

**Ciclo de vida LTS típico**: ~30 meses desde la liberación inicial

### LTS Schedule (2024-2026)

| Versión | Lanzamiento | Soporte Activo | EOL | Estado |
|---------|-------------|----------------|-----|--------|
| v20     | 2023-04-18  | 2025-04-30     | 2026-04-30 | Mantenimiento |
| v22     | 2024-04-23  | 2025-10-15     | 2027-04-30 | Activo |
| v24     | 2025-04-xx  | 2025-10-15     | 2028-04-30 | **Actual LTS** |
| v26     | 2025-10-xx  | 2026-04-15     | 2029-04-30 | Próximo (esperado) |

## Instalación Automática

### Instalación Inicial

```bash
# Instala automáticamente la última versión LTS disponible
make nodejs

# Verifica que se instaló correctamente
node --version
npm --version
```

**¿Qué hace?**
1. Verifica que ASDF está instalado
2. Agrega el plugin de Node.js si no existe
3. Descubre todas las versiones disponibles
4. Filtra solo las versiones LTS (números pares)
5. Selecciona la última disponible
6. Instala esa versión
7. Configura como global en `~/.tool-versions`

### Actualización Automática

```bash
# Comprueba si hay nueva versión LTS y actualiza si es necesario
make nodejs-update
```

**¿Qué hace?**
1. Obtiene la versión LTS actual instalada
2. Obtiene la última versión LTS disponible en ASDF
3. Compara versiones:
   - Si es la misma: muestra que está actualizado
   - Si hay una más nueva: instala y actualiza
4. Confirma la actualización

## Cómo Funciona Técnicamente

### Filtrado de Versiones LTS

```bash
# El Makefile usa este comando para filtrar LTS (números pares)
asdf list all nodejs | grep -E '^[0-9]+\.[0-9]+\.[0-9]+$' | \
  while read v; do
    MAJOR=$(echo $v | cut -d. -f1)
    if (( MAJOR % 2 == 0 )); then
      echo $v
    fi
  done | sort -V | tail -1
```

**Desglose:**
1. `asdf list all nodejs`: Obtiene todas las versiones
2. `grep -E '^[0-9]+\.[0-9]+\.[0-9]+$'`: Filtra solo formato X.Y.Z
3. `MAJOR=$(echo $v | cut -d. -f1)`: Extrae número mayor
4. `if (( MAJOR % 2 == 0 ))`: Verifica si es par (LTS)
5. `sort -V | tail -1`: Ordena y toma la última

### Alternativa Manual

Si prefieres instalar manualmente una versión específica:

```bash
# Ver todas las versiones disponibles
asdf list all nodejs | grep -E '^[0-9]{2}\.' | tail -20

# Instalar versión específica
asdf install nodejs 24.12.0

# Establecer como global
asdf set --home nodejs 24.12.0
```

## Comandos Makefile Disponibles

### `make nodejs`
**Instala la última versión LTS**

```bash
$ make nodejs
```

Salida típica:
```
Installing Node.js LTS (latest)...
ℹ Node.js LTS versions use even major numbers (20, 22, 24, etc.)

  Latest LTS version: 24.12.0
✓ Node.js 24.12.0 already installed
  Setting Node.js 24.12.0 as default...
✓ Node.js 24.12.0 is now the global version

Node.js Release Schedule:
  • v20: Active until 2026-04-30
  • v22: Active until 2027-04-30
  • v24: Active until 2028-04-30
  • v26: Expected October 2025
```

### `make nodejs-update`
**Comprueba y actualiza a nueva LTS si está disponible**

```bash
$ make nodejs-update
```

Salida si está actualizado:
```
Checking for Node.js LTS updates...
  Current version: 24.12.0

  Latest LTS:     24.12.0

✓ Already running latest LTS version
```

Salida si hay actualización:
```
Checking for Node.js LTS updates...
  Current version: 22.11.0

  Latest LTS:     24.12.0

⚠ Newer LTS version available. Installing...
✓ Node.js 24.12.0 already installed

  Setting Node.js 24.12.0 as default...

✓ Updated from 22.11.0 to 24.12.0

v24.12.0
```

## Integración con el Sistema

### `.tool-versions`

El archivo `~/.tool-versions` es donde ASDF guarda tu configuración global:

```
# ~/.tool-versions
nodejs 24.12.0
```

Cuando haces `make nodejs`, se actualiza este archivo.

### Verificación

Para verificar qué versión está en uso:

```bash
# Mostrar versión actual
asdf current nodejs
node --version
npm --version

# Listar todas las versiones instaladas
asdf list nodejs

# Listar todas las disponibles
asdf list all nodejs | head -20
```

## Cambios Manuales

Si necesitas cambiar a una versión específica:

```bash
# Instalar versión específica si no existe
asdf install nodejs 22.11.0

# Cambiar a esa versión globalmente
asdf set --home nodejs 22.11.0

# Verificar cambio
node --version
```

## Automatización Periódica

Para chequear actualizaciones regularmente, puedes agregar a cron:

```bash
# Editar crontab
crontab -e

# Agregar esta línea (chequear cada semana)
0 0 * * 0 cd ~/.dotfiles && make nodejs-update >> /tmp/nodejs-update.log 2>&1
```

O crear un alias:

```bash
# Agregar a ~/.zsh.d/alias.zsh
alias node-check='cd ~/.dotfiles && make nodejs-update'

# Usar:
node-check
```

## Solución de Problemas

### Problema: "ASDF not found"
```
✗ ASDF not found. Install with: make asdf
```
**Solución**: Instala ASDF primero
```bash
make asdf
source ~/.zshrc
make nodejs
```

### Problema: "Could not determine latest Node.js LTS version"
**Solución**: Actualiza el plugin de Node.js
```bash
asdf plugin update nodejs
make nodejs
```

### Problema: Compilación lenta
**Causa**: Node.js se compila desde source
**Solución**: La primera vez es lenta, pero se cachea. Usa `--verbose` para ver progreso:
```bash
asdf install nodejs 24.12.0 --verbose
```

### Problema: Quiero usar versión no-LTS
```bash
# Instala versión específica manualmente
asdf install nodejs 25.1.0  # Versión Current (no-LTS)
asdf set --home nodejs 25.1.0
```

## Monitoreo de Actualizaciones

### Script Manual para Chequear

```bash
#!/bin/bash
# Ver versiones disponibles recientemente
echo "Latest Node.js LTS versions:"
asdf list all nodejs | tail -20 | grep -E '^[0-9]{2}\.'
```

### Via GitHub

Puedes ver el cronograma oficial en:
https://nodejs.org/en/about/releases/

O verificar directamente:
```bash
curl -s https://nodejs.org/dist/ | grep -oE 'v[0-9]+\.[0-9]+\.[0-9]+' | sort -V | uniq | tail -10
```

## Configuración Avanzada

### Cambiar Método de Compilación

Por defecto usa `node-build`. Puedes usar binarios pre-compilados:

```bash
# Usar binarios en lugar de compilar (más rápido)
asdf install nodejs 24.12.0 --latest-precompiled

# O establecer en ~/.asdfrc
echo 'NODEJS_BUILD_SKIP_COMPILATION=yes' >> ~/.asdfrc
```

### Multiples Versiones

ASDF permite tener múltiples versiones instaladas y cambiar fácilmente:

```bash
# Instalar varias versiones
asdf install nodejs 22.11.0
asdf install nodejs 24.12.0

# Listar todas
asdf list nodejs

# Cambiar temporalmente en directorio (crea .tool-versions local)
asdf set nodejs 22.11.0  # Local a este proyecto
asdf set --home nodejs 24.12.0  # Global

# Verificar cual se usa
asdf current nodejs
```

## FAQ

**P: ¿Por qué solo LTS?**
R: LTS es más estable para producción. Tiene ~30 meses de soporte.

**P: ¿Qué pasa con las versiones impares (21, 23, 25)?**
R: Tienen solo ~6 meses de soporte. No recomendadas para uso en producción.

**P: ¿Puedo forzar una versión no-LTS?**
R: Sí, instala manualmente: `asdf install nodejs 25.1.0`

**P: ¿Qué pasa cuando sale Node v26?**
R: `make nodejs` automáticamente instalará v26 cuando esté disponible.

**P: ¿Se pierde npm?**
R: No, npm viene incluido con Node.js.

**P: ¿Cómo actualizo paquetes npm?**
R: `npm install -g npm@latest` actualiza npm a su última versión.

---

**Última actualización**: 2025-12-11
**Versión de Node.js actual**: 24.12.0 LTS
