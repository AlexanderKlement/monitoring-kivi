# monitoring-kivi

Prometheus + Grafana monitoring stack running on `srv3.kivi.bz.it`. Node exporter runs on each monitored server and exposes metrics on port 9100.

## Architecture

```
[monitored servers] :9100  →  [prometheus on srv3] :9090  →  [grafana on srv3] :3000
```

---

## Monitoring server (srv3.kivi.bz.it)

### Start the stack

```bash
docker compose up -d
```

### Upgrade Prometheus or Grafana

1. Edit `docker-compose.yml` and bump the version tags
2. Run:

```bash
docker compose pull
docker compose up -d
```

Grafana dashboards and data are persisted in the `grafana-storage` Docker volume and survive upgrades.

### Reset Grafana admin password

```bash
docker exec -it grafana grafana-cli admin reset-admin-password <newpassword>
```

### Add a new server to monitoring

1. Add the target to `prometheus.yml`:
   ```yaml
   - 'hostname:9100'
   ```
2. Restart Prometheus to pick up the change:
   ```bash
   docker compose restart prometheus
   ```

---

## Monitored servers

### Install node_exporter (fresh server)

```bash
curl -fsSL https://raw.githubusercontent.com/AlexanderKlement/monitoring-kivi/master/install_node_exporter.sh | bash
```

### Upgrade node_exporter

```bash
curl -fsSL https://raw.githubusercontent.com/AlexanderKlement/monitoring-kivi/master/upgrade_node_exporter.sh | bash
```

### Allow monitoring server through UFW

```bash
curl -fsSL https://raw.githubusercontent.com/AlexanderKlement/monitoring-kivi/master/allow_ufw.sh | bash
```

This allows port 9100 only from the monitoring server's IPs and denies it from everywhere else.

---

## Updating node_exporter version

When a new node_exporter release is out:

1. Update `NODE_EXPORTER_VERSION` in both `install_node_exporter.sh` and `upgrade_node_exporter.sh`
2. Commit and push
3. Run the upgrade one-liner on each monitored server

---