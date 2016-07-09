<ri-gen>
    <div class="panel-container">
        <div class="panel first" if={!localStorage.keys}>
            <h2 class="panel-title">Generate keypair</h2>

            <form if={status === 'pending'} onsubmit={generate} class="generate">
                <input type="text" value={username} oninput={updateUsername} placeholder="Username" class="input panel-input first">
                <input type="text" value={email} oninput={updateEmail} placeholder="E-mail (optional)" class="input panel-input">
                <input type="password" value={keyPass} oninput={updateKeyPass} placeholder="Key passphrase" class="input panel-input">
                <input if={storageMethod === 'local'} type="password" value={storePass} oninput={updateStorePass} placeholder="Store passphrase" class="input panel-input">

                <span class="panel-more noselect" onclick={showAdvanced}>{advanced ? 'Hide' : 'Show'} advanced options</span>

                <div if={advanced}>
                    <label class="input-container">
                        Key size
                        <select value={keySize} onchange={updateKeySize} class="select">
                            <option value="2048" selected={keySize === 2048}>2048</option>
                            <option value="4096" selected={keySize === 4096}>4096</option>
                        </select>
                    </label>

                    <label class="input-container">
                        Storage method
                        <select value={storageMethod} onchange={updateStorageMethod} class="select">
                            <option value="local" selected={storageMethod === 'local'}>Encrypt and store in browser</option>
                            <option value="file" selected={storageMethod === 'file'}>Download to my computer</option>
                        </select>
                    </label>
                </div>

                <button type="submit" class="submit panel-submit">Generate</button>
            </form>

            <span if={status === 'generating'}>Generating... This may take some time</span>
            <span if={status === 'done'}>Keypair generated!</span>
        </div>

        <div class="panel" if={status === 'pending'}>
          <a href="/signin" class="link panel-link">I have a key and wish to sign in</a>
        </div>
    </div>

    <script>
        const riot = require('riot');

        const openpgp = require('openpgp');
        const crypto = require('crypto-js');

        this.status = 'pending';
        this.pubkey = '';
        this.privkey = '';

        this.username = 'niels';
        this.email = 'niels.simenon@gmail.com';
        this.keyPass = 'test';
        this.storePass = 'foo';
        this.keySize = 2048;
        this.storageMethod = 'local';

        this.advanced = false;

        this.generate = event => {
            this.status = 'generating';
            this.update();

            openpgp.generateKey({
                userIds: [{
                    name: this.username,
                    email: this.email
                }],
                numBits: this.keySize,
                passphrase: this.keyPass
            }).then(keys => {
                const encryptedPrivateKey = crypto.AES.encrypt(keys.privateKeyArmored, this.storePass).toString();

                localStorage.setItem('privateKey', encryptedPrivateKey);
                localStorage.setItem('publicKey', keys.publicKeyArmored);

                riot.route('/signin');

                this.status = 'pending';
                this.update();
            }).catch(error => {
                console.log(error);
            });
        };

        this.updateUsername = event => { this.username = event.target.value; this.update(); };
        this.updateEmail = event => { this.email = event.target.value; this.update(); };
        this.updateKeyPass = event => { this.keyPass = event.target.value; this.update(); };
        this.updateStorePass = event => { this.storePass = event.target.value; this.update(); };
        this.updateKeySize = event => { this.keySize = event.target.value; this.update(); };
        this.updateStorageMethod =  event => { this.storageMethod = event.target.value; this.update(); };

        this.showAdvanced = event => { this.advanced = !this.advanced; this.update(); };

        this.wipeKeys = event => {
            localStorage.removeItem('keys');

            document.location.reload();
        };

        this.link = event => {
          riot.route(event.target.getAttribute('href'));
        };
    </script>
</ri-gen>
