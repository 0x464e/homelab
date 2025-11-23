#!/usr/bin/env bash
set -euo pipefail

if [[ -f /etc/zfs-telegram.env ]]; then
  source /etc/zfs-telegram.env
else
  echo "Config /etc/zfs-telegram.env not found" >&2
  exit 1
fi

TOKEN="${TG_BOT_TOKEN:?TG_BOT_TOKEN not set}"
CHAT_ID="${TG_CHAT_ID:?TG_CHAT_ID not set}"

send_tg() {
  local text="$1"
  curl -sS \
    -X POST \
    "https://api.telegram.org/bot${TOKEN}/sendMessage" \
    -d "chat_id=${CHAT_ID}" \
    -d "parse_mode=MarkdownV2" \
    --data-urlencode "text=${text}" >/dev/null || true
}

# start scrub
if ! zpool scrub backup; then
  send_tg "*HC4*: FAILED to start scrub"
  exit 1
fi

# wait for scrub to finish (polling)
while zpool status backup | grep -q "scrub in progress"; do
  sleep 300
done

scan_line=$(zpool status backup | grep "scan:" | sed 's/^\s*//')

pool_health=$(zpool status -x backup 2>&1 || true)

full_status=$(zpool status backup 2>&1 || true)

if echo "${pool_health}" | grep -q "pool 'backup' is healthy"; then
  msg="*HC4*: ZFS scrub on pool \`backup\` *OK* ✅

\`\`\`
${scan_line}
\`\`\`"
else
  msg="*HC4*: *ZFS SCRUB ALERT* on pool \`backup\` ❌

\`\`\`
${pool_health}
\`\`\`

Details:
\`\`\`
${full_status}
\`\`\`"
fi

send_tg "${msg}"
