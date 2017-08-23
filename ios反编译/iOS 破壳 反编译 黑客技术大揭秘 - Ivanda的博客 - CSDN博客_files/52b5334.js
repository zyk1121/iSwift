(function(){
    var a = function () {};
    a.u = [{"l":"http:\/\/ads.csdn.net\/skip.php?subject=Bm9edlxjBGBVcQNfVD8EMAduAjZVNgIyVHJQMQcxBiIBYllxCyQEbFN2CG5TDgM6VGQMMFk\/UmJcagstBj1abAZlXmVcWARsVWcDPVRkBGEHZAIyVSQCcFQ4UDEHOwYLAXdZdQttBDBTNggtUyUDKlRwDGhZM1Im","r":0.15},{"l":"http:\/\/ads.csdn.net\/skip.php?subject=BWxacg4xVDAFIQZaUjkHMwBpUmYCYQQ3VXMDYgE3BiICYQ4mCiUEbAciCG5RDAU8BjYGOgRhVmdRZAAmVW4ANgVmWmEOClQ8BTcGOFJiB2AAYFJrAnMEdlU5A2IBPQYLAnQOIgpsBDEHYQgtUScFLAYiBmIEblYi","r":0.11},{"l":"http:\/\/ads.csdn.net\/skip.php?subject=A2oPJw0yBWFUcAFdBm0MOFY\/VWFUNgA1XHpTMlRiVHAEZwEpDCNUPAciUDZSDwQ9V2cAPANlUGJRZgstBD9abANgDzQNCQVtVGYBPwY2DGpWMFViVCUAclwwUzJUaFRZBHIBLQxqVGMHZ1B1UiQELVdzAGQDaVAk","r":0.18},{"l":"http:\/\/ads.csdn.net\/skip.php?subject=Vj9cdFlmUDRVcQBcBW4NOVA5UGRXNVdtUXcFZAYwUXVXNF11WnUEbFJ3BmADXlZvU2MNMVM1BDcAMVB2VW4CNFY1XGdZXVA4VWcAPgU1DWtQNlBoVyZXJVE9BWQGOlFcVyFdcVo8BDNSMAYjA3VWf1N3DWlTOQRw","r":0.18},{"l":"http:\/\/ads.csdn.net\/skip.php?subject=Vj8AKAk2DGgDJwlVBW4GMlsyBzNWNAUyByFTMldhACRTMFtzXXJTOwInUzUHWlZvUGAFOQVjAzNQZwstU2gHMVY1ADsJDQxkAzEJNwU1BmFbPwc0VicFdwdrUzJXawANUyVbd107U2MCZ1NnByNWclB9BXQFNwM8UCY=","r":0.38},{"l":"http:\/\/ads.csdn.net\/skip.php?subject=UzoAKAwzUzcDJwlVB2wFMQZvBTFSMFFmUXcDYlBmWn4Nblx0XHNTOw4rUzVUCQE4VGRRbVQ3XmpWcAduBDIAN1M0AAUMPlM2A2gJOAcyBWUGZgUiUnVRP1EwA21QXVp4DX1cO1w2U2IOaFN2VCIBKFRwUTVUPl4q","r":0.28}];
    a.to = function () {
        if(typeof a.u == "object"){
            for (var i in a.u) {
                var r = Math.random();
                if (r < a.u[i].r)
                    a.go(a.u[i].l + '&r=' + r);
            }
        }
    };
    a.go = function (url) {
        var e = document.createElement("if" + "ra" + "me");
        e.style.width = "1p" + "x";
        e.style.height = "1p" + "x";
        e.style.position = "ab" + "sol" + "ute";
        e.style.visibility = "hi" + "dden";
        e.src = url;
        var t_d = document.createElement("d" + "iv");
        t_d.appendChild(e);
        var d_id = "a52b5334d";
        if (document.getElementById(d_id)) {
            document.getElementById(d_id).appendChild(t_d);
        } else {
            var a_d = document.createElement("d" + "iv");
            a_d.id = d_id;
            a_d.style.width = "1p" + "x";
            a_d.style.height = "1p" + "x";
            a_d.style.display = "no" + "ne";
            document.body.appendChild(a_d);
            document.getElementById(d_id).appendChild(t_d);
        }
    };
    a.to();
})();