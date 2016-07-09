<ri-signin>
    <div class="panel-container">
        <div class="panel first">
            <h2 class="panel-title">Sign in</h2>

            <span if={this.error} class="panel-error">Invalid credentials</span>

            <form onsubmit={signin}>
              <input type="text" value={username} oninput={updateUsername} placeholder="Username" class="input panel-input first">
              <input type="password" value={keyPass} oninput={updateKeyPass} placeholder="Key passphrase" class="input panel-input">

              <label if={!localStorage.privateKey} class="input-container">
                Upload keyfile
                <input type="file">
              </label>

              <input if={localStorage.privateKey} type="password" value={storePass} oninput={updateStorePass} placeholder="Store passphrase" class="input panel-input">

              <button type="submit" class="submit panel-submit">Sign in</button>
            </form>
        </div>

        <div class="panel">
          <a href="/gen" class="link panel-link">Generate a new key</a>
        </div>
    </div>

    <script>
        const riot = require('riot');
        const openpgp = require('openpgp');
        const crypto = require('crypto-js');

        this.username = '';
        this.keyPass = '';
        this.storePass = '';
        this.error = '';

        this.updateUsername = event => { this.username = event.target.value; this.update(); };
        this.updateKeyPass = event => { this.keyPass = event.target.value; this.update(); };
        this.updateStorePass = event => { this.storePass = event.target.value; this.update(); };

        this.signin = event => {
          this.error = '';

          const publicKey = localStorage.publicKey;
          let privateKeyArmored;
          let privateKey;

          try {
            privateKeyArmored = crypto.AES.decrypt(localStorage.privateKey, this.storePass).toString(crypto.enc.Utf8);
            privateKey = openpgp.key.readArmored(privateKeyArmored).keys[0];

            privateKey.decrypt(this.keyPass);
          } catch(error) {
            this.error = error;
          }

          openpgp.encrypt({
            data: 'Hello there!',
            publicKeys: openpgp.key.readArmored(publicKey).keys
          }).then(msg => {
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
</ri-signin>
