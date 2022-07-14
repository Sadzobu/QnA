import consumer from "./consumer"

consumer.subscriptions.create({ channel: "CommentsChannel", question_id: gon.question_id }, {
    connected() {
        this.perform('follow');
    },

    received(data) {
        let parsedData = JSON.parse(data)
        if (parsedData.comment.commentable_type == 'Question') {
            $('.question_comments').append(parsedData.html_content);  
        } else {
            $('#answer_' + parsedData.comment.commentable_id).find('.answer_comments').append(parsedData.html_content);
        }

        
    }
});
