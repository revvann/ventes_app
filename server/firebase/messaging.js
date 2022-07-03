class FirebaseMessaging {
    admin;

    constructor(admin) {
        this.admin = admin;
    }

    async sendMessage() {

        let token = 'cYowJNUxRdSln69ROopDg3:APA91bFkFHy1RqL3qWqLxlk_3c_aiInfkYodmfxDck0uRIhEiNNmG3CdVC2_l4x9Be25uP63CRpyzKoIEkGRBLYrlx5-O_qrCiJIBMTiCdhoZFjOTVXGGpFXP3vTvZA-jlCT_xT9veDl';
        const message = {
            data: {
                type: "chat",
                menu: "0",
                route: "/chatroom",

            },
            notification: {
                title: "My Tytyd",
                body: "My Body",
            },
            token: token,
        };

        admin
            .messaging()
            .send(message)
            .then((response) => {
                console.log("Successfully sent message:", response);
            })
            .catch((error) => {
                console.log("Error sending message:", error);
            });
    }
}

function createMessaging(admin) {
    return new FirebaseMessaging(admin);
}

module.exports = createMessaging;