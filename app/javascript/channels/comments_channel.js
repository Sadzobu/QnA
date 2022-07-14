import consumer from "./consumer"

consumer.subscriptions.create({ channel: "CommentsChannel", question_id: gon.question_id }, {
    connected() {
        this.perform('follow');
    },

    received(data) {
        $('.answers').append(data);
    }
});
