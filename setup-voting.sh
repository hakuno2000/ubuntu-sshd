cd /root
curl https://sh.rustup.rs -sSf | sh -s -- -y
source /root/.profile
curl -sL https://deb.nodesource.com/setup_20.x -o nodesource_setup.sh
bash nodesource_setup.sh
apt install nodejs -y

source /root/.env
git clone https://github.com/decentrio/voting
cd voting
git checkout minh/local-node
sed -i "s#${DEFAULT_WS}#${NEW_WS}#g" server/services/service.ts
sed -i "s#${DEFAULT_RPC}#${NEW_RPC}#g" server/services/service.ts

tee .env > /dev/null <<EOF
SEED_PHRASE="$SEED_PHRASE"
OPENAI_API_KEY="$OPENAI_API_KEY"
EOF

npm install
npm install -g pm2
pm2 start "npx ts-node server/server.ts" --name npx-spam
pm2 start "rm -r data && mkdir data && /root/.cargo/bin/cargo run spam" --name cargo-spam

crontab -l > newcron
echo "0 * * * * pm2 stop npx-spam cargo-spam && pm2 restart npx-spam && pm2 restart cargo-spam" >> newcron
crontab newcron && rm newcron
