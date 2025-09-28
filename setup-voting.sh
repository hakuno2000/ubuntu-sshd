curl https://sh.rustup.rs -sSf | sh -s -- -y
source .profile
curl -sL https://deb.nodesource.com/setup_20.x -o nodesource_setup.sh
bash nodesource_setup.sh
apt install nodejs -y

git clone https://github.com/decentrio/voting
cd voting
git checkout minh/local-node
sed -i 's#wss://abc.xyz#ws://127.0.0.1:9944#g' server/services/service.ts
sed -i 's#https://abc.xyz#http://127.0.0.1:9944#g' server/services/service.ts

tee .env > /dev/null <<'EOF'
SEED_PHRASE = ""
OPENAI_API_KEY = ""
EOF

npm install
npm install -g pm2
pm2 start "npx ts-node server/server.ts" --name npx-spam
pm2 start "rm -r data && mkdir data && /root/.cargo/bin/cargo run spam" --name cargo-spam
