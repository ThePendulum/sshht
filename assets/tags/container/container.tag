<ri-container>
    <ri-gen if={location === 'gen'}></ri-gen>
    <ri-signin if={location === 'signin'}></ri-signin>

    <script>
        const riot = require('riot');

        riot.route.base('/');
        riot.route.start();

        riot.route((collection, id, action) => {
          if(collection) {
            this.location = collection;
          } else {
            if(localStorage.privateKey) {
              this.location = 'signin';
            } else {
              this.location = 'gen';
            }
          }

          this.update();
        });

        riot.route.exec();
    </script>
</ri-container>
