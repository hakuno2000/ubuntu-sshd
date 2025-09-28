while true
do
    sleep 1h
    pm2 stop npx-spam cargo-spam && pm2 restart npx-spam && pm2 restart cargo-spam
done
