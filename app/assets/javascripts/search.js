var discs = new Bloodhound({
    datumTokenizer: function(data) {
        return data.name.split(' ').concat(data.bunk.split("-")[1]).concat(data.bunk).concat(data.bunk.split("-").join(''));
    },
    queryTokenizer: Bloodhound.tokenizers.whitespace,
    prefetch: {
        url: "../data.json",
        ttl: 1
    }
}),

    on = function() {
        $('#menu-search').typeahead({
            // `ttAdapter` wraps the suggestion engine in an adapter that
            // is compatible with the typeahead jQuery plugin
            hint: false,
            highlight: true
        }, {
            source: discs.ttAdapter(),
            displayKey: function(suggestion) {
                return suggestion.name + " " + suggestion.bunk;
            },
            templates: {
                suggestion: function(suggestion) {
                    return "<p><b>" + suggestion.name + "</b> - <small>" + suggestion.bunk + "</small></p>";
                }
            }
        });
    },

    off = function() {
        $('#menu-search').typeahead('destroy');
    },

    search = function(query) {
        var output = [];
        discs.ttAdapter()(query, function(suggestions) {
            jQuery.each(suggestions, function(index, item) {
                output.push(item);
            });
        });
        return output;
    };

    discs.initialize();
    on();

    $("#search_form").submit(function() {
        var query = $("input#menu-search.tt-input").val(),
            id_array = search(query).map(function(i) {
                return i.id;
            });
        $("#id_array").val(id_array);
    });