//        {
//            "name": "Apple",
//            "image": "pics/apple.jpg",
//            "cost": 2.45
//        }


function serialize(model) {
    var res = "{ \"fruits\": [\n";

    console.log("count: " + model.count);

    for(var i = 0; i < model.count; ++i) {
        res += "\n{\t";
        var e = model.get(i);
        res += "\"name\": \""   +　e.name + "\",\n\t";
        res += "\"image\": \"" + e.image + "\",\n\t";
        res += "\"description\": \"" + e.description + "\",\n\t";
        res += "\"cost\": " + e.cost + "\n\t";

        // The last one should not have the ending ","
        if ( i === model.count -1)
            res += "\n}";
        else
            res += "\n},";
    }

    res += "\n]}";

    console.log("res: " + res );
    return res;
}
