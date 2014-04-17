function sort_by(field, reverse, primer) {

    var key = primer ?
            function (x) {
                return primer(x[field]);
        } :
            function (x) {
                return x[field];
        };

    reverse = [-1, 1][+ !! reverse];

    return function (a, b) {
        var ak = key(get_json(a)),
            bk = key(get_json(b)),
            output;
            if (ak > bk) {
                output = 1;
            } else if (ak < bk) {
                output = -1;
            } else {
                if (last_name(get_json(a).name) > last_name(get_json(b).name)) {
                    output = -1;
                } else if (last_name(get_json(a).name) < last_name(get_json(b).name)) {
                    output = 1;
                } else {
                    output = 0;
                }
            }
        return reverse * output;
    };

}

function get_json(dom) {
    var t = dom.children;
    return {
        name: t[0].innerHTML,
        bunk: t[1].innerHTML,
        white: parseInt(t[2].innerHTML),
        orange: parseInt(t[3].innerHTML),
        blue: parseInt(t[4].innerHTML),
        paid: $(t[5]).find("input.btn").hasClass("btn-success"),
        price: parseInt($(t[5]).find("input.btn").val().replace('$', '')),
        received: $(t[6]).find("input.btn").val() === "Yes"
    };
}

function last_name(x) {
    return x.split(' ')[1];
}

var orders = $("table tr").slice(1),
    current_state = {field: "created_at", reverse: true};

function sort_table(field, reverse) {
    var primer = field === "name" ? last_name : null;
    orders.sort(sort_by(field, reverse, primer));
    orders.detach().appendTo($("table tbody"));
    current_state.field = field;
    current_state.reverse = reverse;
}

$("a.sort").click(function (e) {
    var field = e.target.id,
        reverse = field === current_state.field ? !current_state.reverse : (field === 'name' || field === 'bunk');
        sort_table(field, reverse);
});