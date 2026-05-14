# Frontend Despacho - React + Vite

Frontend de Innovatech Chile. Interfaz para gestión de despachos, construido con React 18, Vite 5 y Tailwind CSS.

---

## Tecnologías

- React 18 + Vite 5
- Tailwind CSS
- Axios para peticiones HTTP
- React Router DOM v6
- SweetAlert2

---

## Levantar en local (sin Docker)

```bash
npm install
npm run dev
```

## Levantar con Docker

```bash
# Build de la imagen
docker build -t front-despacho .

# Correr el contenedor
docker run -d -p 80:80 --name front-despacho front-despacho
```

Accede en: http://localhost

---

## Dockerfile

Usa **multi-stage build**:
- **Stage 1 (builder)**: Node 18 Alpine compila la app con `npm run build`
- **Stage 2 (production)**: Nginx 1.25 Alpine sirve los archivos estáticos

Beneficios: imagen final ~25MB en vez de ~500MB, sin dependencias de desarrollo.

---

## CI/CD

El pipeline `.github/workflows/ci-cd.yml` se activa al hacer push a la rama `deploy`:

```
push deploy → build imagen → push Docker Hub → deploy EC2 via SSH
```

### Secrets requeridos

`DOCKERHUB_USERNAME`, `DOCKERHUB_TOKEN`, `EC2_FRONT_HOST`, `EC2_USERNAME`, `EC2_SSH_KEY`
