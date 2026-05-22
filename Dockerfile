# ===========================================
# Stage 1: Build API (NestJS)
# ===========================================
FROM node:20-alpine AS api-builder
WORKDIR /api
COPY trackpro-api/package*.json ./
RUN npm ci
COPY trackpro-api/ .
RUN npm run build

# ===========================================
# Stage 2: Build Web (Next.js)
# ===========================================
FROM node:20-alpine AS web-builder
WORKDIR /web
COPY trackpro-web/package*.json ./
RUN npm ci
COPY trackpro-web/ .

ARG NEXT_PUBLIC_API_URL=http://51.161.107.103:4000
ARG NEXT_PUBLIC_MAPBOX_TOKEN
ENV NEXT_PUBLIC_API_URL=$NEXT_PUBLIC_API_URL
ENV NEXT_PUBLIC_MAPBOX_TOKEN=$NEXT_PUBLIC_MAPBOX_TOKEN

RUN npm run build

# ===========================================
# Stage 3: Runtime (API + Web + SQLite)
# ===========================================
FROM node:20-alpine

RUN apk add --no-cache supervisor

# --- API runtime ---
WORKDIR /api
COPY trackpro-api/package*.json ./
RUN npm ci --omit=dev
COPY --from=api-builder /api/dist ./dist
COPY --from=api-builder /api/prisma ./prisma
RUN npx prisma generate

# --- Web runtime ---
WORKDIR /web
COPY --from=web-builder /web/.next/standalone ./
COPY --from=web-builder /web/.next/static ./.next/static
COPY --from=web-builder /web/public ./public

# --- Config y startup ---
COPY supervisord.conf /etc/supervisord.conf
COPY start.sh /start.sh
RUN sed -i 's/\r//' /start.sh && chmod +x /start.sh

RUN mkdir -p /data

EXPOSE 3000 4000

CMD ["/start.sh"]
