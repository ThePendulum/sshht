<ri-home>
    <div class="panel-container">
        <div class="panel">
            <h2 class="panel-title">Generate keypair</h2>

            <form if={status === 'pending'} onsubmit={generate} class="generate">
                <input type="text" value={username} placeholder="Username" class="input panel-input">
                <input type="text" value={email} placeholder="E-mail" class="input panel-input">
                <input type="password" value={keyPass} placeholder="Key passphrase" class="input panel-input">
                <input type="password" value={storePass} placeholder="Store passphrase" class="input panel-input last">

                <button type="submit" class="submit panel-submit">Generate!</button>
            </form>

            <span if={status === 'generating'}>Generating... This may take some time</span>

            <span if={status === 'done'}>Keypair generated!</span>
        </div>
    </div>

    <script>
        const promisify = require('es6-promisify');
        const openpgp = require('openpgp');
        const crypto = require('crypto-js');

        this.status = 'pending';
        this.pubkey = '';
        this.privkey = '';

        this.username = 'niels';
        this.email = 'niels.simenon@gmail.com';
        this.keyPass = 'test';
        this.storePass = 'foo';

        this.generate = event => {
            event.preventDefault();

            this.status = 'generating';

            openpgp.generateKey({
                userIds: [{
                    name: this.username,
                    email: this.email
                }],
                numBits: 2048,
                passphrase: this.keyPass,
                comment: ''
            }).then(keys => {
                const encryptedKeys = crypto.AES.encrypt(JSON.stringify({
                    private: keys.privateKeyArmored,
                    public: keys.publicKeyArmored
                }), this.storePass);

                localStorage.setItem('keys', encryptedKeys.toString());

                this.status = 'done';
                this.update();

                return openpgp.encrypt({
                    publicKeys: openpgp.key.readArmored(keys.publicKeyArmored).keys,
                    data: 'Hi there, how are you?'
                });
            }).then(msg => {
                const keys = crypto.AES.decrypt(localStorage.keys, this.storePass);
                const privateKeyText = JSON.parse(keys.toString(crypto.enc.Utf8)).private;
                const privateKey = openpgp.key.readArmored(privateKeyText).keys[0];

                privateKey.decrypt(this.keyPass);

                return openpgp.decrypt({
                    message: openpgp.message.readArmored(msg.data),
                    privateKey: privateKey
                });
            }).then(msg => {
                console.log(msg.data);
            }).catch(error => {
                console.log(error);
            });
        };
    </script>
</ri-home>
