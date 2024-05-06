$(document).ready(
	function () {			
		$('.fancybox').fancybox({						
			autoCenter: false,
			helpers: {
				overlay: {
					fixed: false
				}
			}
		});
	}
);

function dowload_counter(file_name) {
    var str = "/cgi-bin/scripts/download_counter.pl?filename=" + file_name;
    $.ajax({
        url: str
    });

    return true;
}

