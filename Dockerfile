# ================================
# STAGE 1: Build
# ================================
FROM node:18-alpine AS builder

# Usuario no root para el build
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

WORKDIR /app

# Copiar dependencias primero (mejor cache de capas)
COPY package*.json ./
RUN npm ci --only=production=false

# Copiar el resto del código
COPY . .

# Build de producción
RUN npm run build

# ================================
# STAGE 2: Serve con Nginx
# ================================
FROM nginx:1.25-alpine AS production

# Eliminar config default de nginx
RUN rm /etc/nginx/conf.d/default.conf

# Copiar nuestra configuración personalizada
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Copiar el build generado
COPY --from=builder /app/dist /usr/share/nginx/html

# Nginx corre como nobody por defecto en alpine (mínimo privilegio)
RUN chown -R nginx:nginx /usr/share/nginx/html && \
    chmod -R 755 /usr/share/nginx/html

EXPOSE 80

HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
  CMD wget -qO- http://localhost/ || exit 1

CMD ["nginx", "-g", "daemon off;"]
