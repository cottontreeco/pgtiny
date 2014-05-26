function updateCountdown() {
// 140 is the max message length
    var txt = jQuery('#review_remark').val()
    var cnt = txt.length;
    var limit = 140;
    if (cnt > limit) {
        jQuery('#review_remark').val(txt.substring(0, limit));
    } else {
        jQuery('.countdown').text((limit - cnt) + ' characters remaining');
    }
}

jQuery(document).ready(function($) {
  updateCountdown();
  $('#review_remark').change(updateCountdown);
  $('#review_remark').keyup(updateCountdown);
});