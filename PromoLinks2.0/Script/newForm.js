'use strict';

//jQuery
if (typeof jQuery == 'undefined') {
    getScript('../../Lib/jquery-1.11.3/jquery-1.11.3.js', function () {
		if (typeof jQuery=='undefined') {
		    // Super failsafe - still somehow failed...
		    alert('failed to load jQuery library.');
		} else {
			// jQuery loaded! Make sure to use .noConflict just in case
		    init();
		}
	});	
} else { // jQuery was already loaded
    init();
};

//MAIN
function init() {
    $(document).ready(function () {
        hideDescriptionInput('BackgroundImage');
        hideDescriptionInput('LinkLocation');

        //Apply event for BackgroundImageType
        $(getFields('BackgroundImageType')).find('select').change(function () {
            var backgroundImageType = $(this).val();
            if (backgroundImageType == "Icon") {
                $(getFields('IconPath')).parent().show();
                $(getFields('IconColor')).parent().show();
                $(getFields('IconSize')).parent().show();
                $(getFields('BackgroundImage')).parent().hide()
                $('#iconPicker').show()
            } else if (backgroundImageType == "Image") {
                $(getFields('IconPath')).parent().hide();
                $(getFields('IconColor')).parent().hide();
                $(getFields('IconSize')).parent().hide();
                $(getFields('BackgroundImage')).parent().show()
                $('#iconPicker').hide()
            }
        });
        $(getFields('BackgroundImageType')).find('select').change();
        
        //inject css
        $('head').append("<link rel='stylesheet' href='../../Content/App.css' />");
        $('head').append("<link rel='stylesheet' href='../../Lib/font-awsome-4.5.0/css/font-awesome.min.css' />");
        $('head').append("<link rel='stylesheet' href='../../Lib/o365-icons/o365-icons.css' />");
        $('head').append("<link rel='stylesheet' href='../../Lib/bootstrap-3.3.6/css/bootstrap-glyphicons-only.css' />");
        $('head').append("<link rel='stylesheet' href='../../Lib/ionicons-2.0.1/css/ionicons.min.css' />");
        $('head').append("<link rel='stylesheet' href='../../Content/Tile.css' />");

        //inject color picker
        $(getFields('IconColor')).children().hide();
        $(getFields('IconColor')).prepend("<input id='iconColorPicker' class='notOOTB' type='color' value='#FFFFFF' />")
        $('#iconColorPicker').change(function () { $(getFields('IconColor')).find('input:not(.notOOTB)').val($('#iconColorPicker').val()) })

        $(getFields('BackgroundColor')).children().hide();
        $(getFields('BackgroundColor')).prepend("<input id='backgroundColorPicker' class='notOOTB' type='color' value='#0072c6' />")
        $('#backgroundColorPicker').change(function () { $(getFields('BackgroundColor')).find('input:not(.notOOTB)').val($('#backgroundColorPicker').val()) })

        //inject range input
        $(getFields('IconSize')).prepend("<input type='range' id='iconSizeRangePicker' class='notOOTB' value='100' max='300'>");
        $(getFields('IconSize')).find('input:not(.notOOTB)').change(function () { $('#iconSizeRangePicker').val($(this).val()) });
        $('#iconSizeRangePicker').change(function () { $(getFields('IconSize')).find('input:not(.notOOTB)').val($('#iconSizeRangePicker').val()) });

        $(getFields('Width')).prepend("<input type='range' id='widthRangePicker' class='notOOTB' value='150' max='400'>");
        $(getFields('Width')).find('input:not(.notOOTB)').change(function () { $('#widthRangePicker').val($(this).val()) });
        $('#widthRangePicker').change(function () { $(getFields('Width')).find('input:not(.notOOTB)').val($('#widthRangePicker').val()) });

        $(getFields('Height')).prepend("<input type='range' id='heightRangePicker' class='notOOTB' value='150' max='400'>");
        $(getFields('Height')).find('input:not(.notOOTB)').change(function () { $('#heightRangePicker').val($(this).val()) });
        $('#heightRangePicker').change(function () { $(getFields('Height')).find('input:not(.notOOTB)').val($('#heightRangePicker').val()) });
        

        //inject iconPicker
        $($('#DeltaPlaceHolderMain > div')[0]).append('<div id="formAside"><div id="previewBox" class="containerBox"><h2>Tile Preview</h2><div></div></div><div id="iconPicker" class="containerBox"><a class="iconInfo" title="Search for icons." target="_blank" href="../../Pages/Icons.aspx"><i class="ion ion-search"></i></a><h2>Icon Picker</h2><div></div></div></div>')
        
        //Get icons
        var icons = null;
        $.ajax({
            async: false,
            url: "../../Lib/icon-list.json.txt",
            success: function (results) {
                icons = JSON.parse(results)
            },
            error: function (err) {
                alert('failed to load icon data.');
            }
        });

        //Apply icons
        if (icons) {
            $.each(icons["fa-icons"].icons, function (index, value) {
                $('#iconPicker > div').append("<i title= '" + value.className + "'class='fa " + value.className + "' icon='" + value.className + "'></i>");
            });
            $.each(icons["o365i-icons"].icons, function (index, value) {
                $('#iconPicker > div').append("<i title= '" + value.className + "' class='o365i " + value.className + "' icon='" + value.className + "'></i>")
            });
            $.each(icons["glyphicon-icons"].icons, function (index, value) {
                $('#iconPicker > div').append("<i title= '" + value.className + "' class='glyphicon " + value.className + "' icon='" + value.className + "'></i>")
            });
            $.each(icons["ionicons"].icons, function (index, value) {
                $('#iconPicker > div').append("<i title= '" + value.className + "' class='ion " + value.className + "' icon='" + value.className + "'></i>")
            });
        }

        //Apply #iconPicker event
        $('#iconPicker i').click(function () {
            $('#iconPicker .selected').removeClass('selected');
            $(this).addClass('selected');
            $(getFields('IconPath')).find('input').val($(this).attr('icon'));
            updatePreview();
        })

        //Apply OOTB input events
        setEventReciever();
        updatePreview();

        //TODO: Cant get dialog to work x-frame-options
        $(getFields('LaunchBehavior')).find('option[value^=Dialog]').attr('disabled', 'disabled').html('Dialog (NOTWORKING)')
    });
}

//events for all imputs
function setEventReciever() {
    $(getFields('Title')).find('input').keyup(updatePreview).change(updatePreview);
    $(getFields('Description')).find('textarea').keyup(updatePreview).change(updatePreview);
    $(getFields('BackgroundImageType')).find('select').change(updatePreview);
    $(getFields('BackgroundImage')).find('input').change(updatePreview);
    $(getFields('IconPath')).find('input').keyup(updatePreview).change(updatePreview);
    $(getFields('IconSize')).find('input').keyup(updatePreview).change(updatePreview);
    $(getFields('IconColor')).find('input').change(updatePreview);
    $(getFields('BackgroundColor')).find('input').change(updatePreview);
    $(getFields('Width')).find('input').keyup(updatePreview).change(updatePreview);
    $(getFields('Height')).find('input').keyup(updatePreview).change(updatePreview);
}

//update preview
function updatePreview() {
    var preview = {
        Title: $(getFields('Title')).find('input').val(),
        Description: $(getFields('Description')).find('textarea').val(),
        BackgroundImageType: $(getFields('BackgroundImageType')).find('select').val(),
        BackgroundImage: { Url: $(getFields('BackgroundImage')).find('input').val() },
        IconPath: $(getFields('IconPath')).find('input').val(),
        IconSize: parseInt($(getFields('IconSize')).find('input').val()),
        IconColor: $(getFields('IconColor')).find('input').val(),
        BackgroundColor: $(getFields('BackgroundColor')).find('input').val(),
        Width: parseInt($(getFields('Width')).find('input').val()),
        Height: parseInt($(getFields('Height')).find('input').val())
    };

    $('#previewBox > div').html(createTile(preview));
}
function createTile(json) {
    var HTML_a = '<a href="#"></a>';
    //PLItem Structure
    HTML_a = $(HTML_a).html('<li class="PLItem"><div class="PLOverlay"><div class="PLTitle"></div><div class="PLDescription"></div></div></li>')

    //TileWidth
    HTML_a = $(HTML_a).children().width(json.Width).parent();

    //TileHeight
    HTML_a = $(HTML_a).children().height(json.Height).parent();

    //BackgroundImageType, IconPath, BackgroundImage
    if (json.BackgroundImageType == 'Icon') {
        var iconLib = json.IconPath.substring(0, json.IconPath.indexOf('-'))
        HTML_a = $(HTML_a).children().addClass('PLIcon ' + iconLib + ' ' + json.IconPath).parent()
    }
    else if (json.BackgroundImageType == 'Image') {
        HTML_a = $(HTML_a).children().addClass('PLImg').prepend('<img src="' + json.BackgroundImage.Url + '" />').parent()
    }

    //IconSize
    HTML_a = $(HTML_a).children().css('font-size', json.IconSize).parent();

    //IconColor
    HTML_a = $(HTML_a).children().css('color', json.IconColor).parent();

    //BackgroundColor
    HTML_a = $(HTML_a).children().css('background-color', json.BackgroundColor).parent();

    //Title
    HTML_a = $(HTML_a).find('.PLTitle').prepend(json.Title).closest('a');

    //Description
    if (json.Description) {
        HTML_a = $(HTML_a).find('.PLDescription').html(json.Description.replace(/\n/g, "<br/>")).closest('a')
    }
    
    return HTML_a;
}

//hide description on hyperlink fields
function hideDescriptionInput(fieldName) {
    $(getFields(fieldName)).find('.ms-formdescription:eq(1)').hide();
    $(getFields(fieldName)).find('input:eq(1)').hide();
    $(getFields(fieldName)).find('br:eq(1)').hide();
}

//Selecting Field Inputs
function getFields(attribute) {
    var returnValue;
    $("table.ms-formtable td").each(function () {
        if (this.innerHTML.indexOf('FieldInternalName="' + attribute + '"') != -1 || this.innerHTML.indexOf('FieldInternalName=\'' + attribute + '\'') != -1) {
            returnValue = $(this);
        }
    });
    return returnValue;
}
function findComment(attribute) {
    var returnValue = false;
    $("table.ms-formtable td").each(function () {
        if (this.innerHTML.indexOf(attribute) != -1) {
            returnValue = true;
        }
    });
    return returnValue;
}


function getScript(url, success) {
    var script = document.createElement('script');
    script.src = url;
    var head = document.getElementsByTagName('head')[0],
    done = false;
    // Attach handlers for all browsers
    script.onload = script.onreadystatechange = function () {
        if (!done && (!this.readyState || this.readyState == 'loaded' || this.readyState == 'complete')) {
            done = true;
            // callback function provided as param
            success();
            script.onload = script.onreadystatechange = null;
            head.removeChild(script);
        };
    };
    head.appendChild(script);
};

function getValueFromSetting(Key) {
    $.ajax({
        url: "../_api/web/lists/getByTitle('Settings')/items?$select=Value&$filter=Key eq '" + Key + "'&top=1",
        contentType: "application/json;odata=verbose;",
        headers: { "accept": "application/json;odata=verbose;" },
        success: function (data) {
            console.log(data.d.results[0].Value);
        },
        error: function (err) {
            console.alert(data);
            alert('Failed to retrieve setting data. Please try reloading or contact the SharePoint admin.')
        }
    });
}