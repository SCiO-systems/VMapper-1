<script>
    function showEventTypePrompt(itemId, eventType) {
        if (!eventType) {
            eventType = "";
        }
        let itemData = eventData.get(itemId);
        bootbox.prompt({
            title: "Please select the event type",
            inputType: 'select',
            value: eventType,
            inputOptions: [
                    {text: 'Choose one...', value: ''},
                    {text: 'Planting',      value: 'planting'},
                    {text: 'Irrigation',    value: 'irrigation'},
                    {text: 'Fertilizer',    value: 'fertilizer'},
                    {text: 'Harvest',       value: 'harvest'}
                ],
            callback: function(result){ 
                if (!result) {
                    if (result === "") {
                        showEventTypePrompt();
                    } else {
                        removeEvent();
                    }
                } else {
                    itemData.event = result;
                    showEventDataDialog(itemData);
                }
            }
        });
    }
    
    function showEventDataDialog(itemData, editFlg) {
        let buttons = {
            cancel: {
                label: "Cancel",
                className: 'btn-default',
                callback: removeEvent
            },
            back: {
                label: "&nbsp;Back&nbsp;",
                className: 'btn-default',
                callback: function(){
                    showEventTypePrompt(itemData.id, itemData.event);
                }
            },
            ok: {
                label: "&nbsp;Save&nbsp;",
                className: 'btn-primary',
                callback: function(){
                    $('.event-input-item').each(function () {
                        if ($(this).val().toString().trim() !== "") {
                            let varName = $(this).attr("name");
                            let varValue = $(this).val();
                            if (varName === "start") {
                                varValue = dateUtil.toLocaleStr(varValue);
                            }
                            editEvent(varName, varValue);
                        }
                    });
                }
            }
        };
        if (editFlg) {
            delete buttons.cancel.callback;
            delete buttons.back;
        }
        let promptClass = 'event-input-' + itemData.event;
        let dialog = bootbox.dialog({
            title: "Please input event data",
            size: 'large',
            message: $("." + promptClass).html(),
            buttons: buttons
        });
        dialog.init(function(){
//            $('[name=crop_name]').val($('#crid').find(":selected").text());
//            $('[name=crid]').val($('#crid').val());
            $("." + promptClass + " input").val("");
            for (let key in itemData) {
                $('[name=' + key + ']').val(itemData[key]);
            }
            if (itemData.start) {
                $('[name=start]').val(dateUtil.toYYYYMMDDStr(itemData.start));
            } else {
                $('[name=start]').val(dateUtil.toYYYYMMDDStr(new Date(defaultDate())));
            }
        });
    }
    
    function rangeNumInput(target) {
        let value = target.value;
        $('[name=' + target.name + ']').val(value);
    }
    
    function rangeNumInputSP(target) {
        let name = target.name;
        let value;
        if (name === "hastg_num") {
            value = "GS" + target.value.padStart(3, "0");
            $('[name=hastg]').val(value);
        } else {
            rangeNumInput(target);
        }
    }
</script>

<!-- Timeline context menu Dialog -->
<ul class='event-menu'>
    <li>One-time Event</li>
    <li>Weekly Event</li>
    <li>Monthly Event</li>
    <li>Customized Event</li>
</ul>

<!-- Planting Dialog -->
<div class="event-input-planting" hidden>
    <p></p>
    <div class="col-sm-12">
        <!-- 1st row -->
        <div class="form-group col-sm-12">
            <label class="control-label">Event Name</label>
            <div class="input-group col-sm-12">
                <input type="text" name="content" class="form-control event-input-item" value="" >
            </div>
        </div>
        <!-- 2nd row -->
        <div class="form-group col-sm-4">
            <label class="control-label">Event Type</label>
            <div class="input-group col-sm-12">
                <input type="text" name="event" class="form-control event-input-item" value="planting" readonly >
            </div>
        </div>
        <div class="form-group col-sm-4">
            <label class="control-label" for="cul_id">Planting Date</label>
            <div class="input-group col-sm-12">
                <input type="date" name="start" class="form-control event-input-item" value="">
            </div>
        </div>
        <div class="form-group col-sm-4">
            <label class="control-label" for="cul_id">Emergence Date</label>
            <div class="input-group col-sm-12">
                <input type="date" name="edate" class="form-control event-input-item" value="">
            </div>
        </div>
        <!-- 3rd row -->
        <div class="form-group col-sm-4">
            <label class="control-label" for="plma">Planting Method *</label>
            <div class="input-group col-sm-12">
                <select name="plma" class="form-control event-input-item" data-placeholder="Choose a method..." required>
                    <option value=""></option>
                    <option value="B">Bedded</option>
                    <option value="S">Dry seed</option>
                    <option value="T">Transplants</option>
                    <option value="N">Nursery</option>
                    <option value="P">Pregerminated seed</option>
                    <option value="R">Ratoon</option>
                    <option value="V">Vertically planted sticks</option>
                    <option value="H">Horizontally planted sticks</option>
                    <option value="I">Inclined (45o) sticks</option>
                    <option value="C">Cutting</option>
                </select>
            </div>
        </div>
        <div class="form-group col-sm-4">
            <label class="control-label" for="plds">Planting Distribution *</label>
            <div class="input-group col-sm-12">
                <select name="plds" class="form-control event-input-item" data-placeholder="Choose a type of distribution..." required>
                    <option value=""></option>
                    <option value="R">Rows</option>
                    <option value="H">Hills</option>
                    <option value="U">Uniform/Broadcast</option>
                </select>
            </div>
        </div>
        <div class="form-group col-sm-4">
            <label class="control-label" for="plrs">Row Spacing (cm) *</label>
            <div class="input-group col-sm-12">
                <div class="col-sm-7">
                    <input type="range" name="plrs" step="1" max="300" min="1" class="form-control" value="" placeholder="Row spacing (cm)" data-toggle="tooltip" title="Row spacing (cm)" oninput="rangeNumInput(this)">
                </div>
                <div class="col-sm-5">
                    <input type="number" name="plrs" step="1" max="999" min="1" class="form-control event-input-item" value="" oninput="rangeNumInput(this)" required >
                </div>
            </div>
        </div>
        <!-- 4th row -->
        <div class="form-group col-sm-6">
            <label class="control-label" for="plrd">Row Direction (degree from north) *</label>
            <div class="input-group col-sm-12">
                <div class="col-sm-7">
                    <input type="range" name="plrd" step="1" max="360" min="1" class="form-control" value="" placeholder="Row Direction (degree from north)" data-toggle="tooltip" title="Row Direction (degree from north)" oninput="rangeNumInput(this)">
                </div>
                <div class="col-sm-5">
                    <input type="number" name="plrd" step="10" max="360" min="1" class="form-control event-input-item" value="" oninput="rangeNumInput(this)" required >
                </div>
            </div>
        </div>
        <div class="form-group col-sm-6">
            <label class="control-label" for="pldp">Planting Depth (cm) *</label>
            <div class="input-group col-sm-12">
                <div class="col-sm-7">
                    <input type="range" name="pldp" step="1" max="100" min="1" class="form-control" value="" placeholder="Planting Depth (cm)" data-toggle="tooltip" title="Planting Depth (cm)" oninput="rangeNumInput(this)">
                </div>
                <div class="col-sm-5">
                    <input type="number" name="pldp" step="1" max="999" min="1" class="form-control event-input-item" value="" oninput="rangeNumInput(this)" required >
                </div>
            </div>
        </div>
        <!-- 5th row -->
        <div class="form-group col-sm-6">
            <label class="control-label" for="plpop">Plant population at Seeding (plants/m2) *</label>
            <div class="input-group col-sm-12">
                <div class="col-sm-7">
                    <input type="range" name="plpop" step="0.1" max="10" min="0.1" class="form-control" value="" placeholder="Plant population at Seeding (plants/m2)" data-toggle="tooltip" title="Plant population at Seeding (plants/m2)" oninput="rangeNumInput(this)">
                </div>
                <div class="col-sm-5">
                    <input type="number" name="plpop" step="1" max="9999" min="1" class="form-control event-input-item" value="" oninput="rangeNumInput(this)" required >
                </div>
            </div>
        </div>
        <div class="form-group col-sm-6">
            <label class="control-label" for="plpoe">Plant population at Emergence (plants/m2)</label>
            <div class="input-group col-sm-12">
                <div class="col-sm-7">
                    <input type="range" name="plpoe" step="0.1" max="10" min="0.1" class="form-control" value="" placeholder="Plant population at Emergence (plants/m2)" data-toggle="tooltip" title="Plant population at Emergence (plants/m2)" oninput="rangeNumInput(this)">
                </div>
                <div class="col-sm-5">
                    <input type="number" name="plpoe" step="1" max="9999" min="1" class="form-control event-input-item" value="" oninput="rangeNumInput(this)" required >
                </div>
            </div>
        </div>
        <!-- 6th row -->
<!--        <div class="form-group col-sm-4">
            <label class="control-label" for="cul_id">Crop</label>
            <div class="input-group col-sm-12">
                <input type="text" name="crop_name" class="form-control" value="" readonly >
                <input type="hidden" name="crid" class="form-control event-input-item" value="" >
            </div>
        </div>
        <div class="form-group has-feedback col-sm-4">
            <label class="control-label" for="cul_id">Cultivar ID *</label>
            <div class="input-group col-sm-12">
                <input type="text" name="cul_id" class="form-control event-input-item" value="" required >
            </div>
        </div>-->
    </div>
    <p>&nbsp;</p>
</div>

<!-- Irrigation Dialog -->
<div class="event-input-irrigation" hidden>
    <p></p>
    <div class="col-sm-12">
        <!-- 1st row -->
        <div class="form-group col-sm-12">
            <label class="control-label">Event Name</label>
            <div class="input-group col-sm-12">
                <input type="text" name="content" class="form-control event-input-item" value="" >
            </div>
        </div>
        <!-- 2nd row -->
        <div class="form-group col-sm-4">
            <label class="control-label">Event Type</label>
            <div class="input-group col-sm-12">
                <input type="text" name="event" class="form-control event-input-item" value="fertilizer" readonly >
            </div>
        </div>
        <div class="form-group col-sm-4">
            <label class="control-label" for="cul_id">Event Date</label>
            <div class="input-group col-sm-12">
                <input type="date" name="start" class="form-control event-input-item" value="">
            </div>
        </div>
        <div class="form-group col-sm-4">
            <label class="control-label" for="ireff">Efficiency (fraction)</label>
            <div class="input-group col-sm-12">
                <div class="col-sm-7">
                    <input type="range" name="ireff" step="0.05" max="1" min="0" class="form-control" value="" placeholder="Irrigation Efficiency (fraction)" data-toggle="tooltip" title="Irrigation Efficiency (fraction)" oninput="rangeNumInput(this)">
                </div>
                <div class="col-sm-5">
                    <input type="number" name="ireff" step="0.05" max="1" min="0" class="form-control event-input-item" value="" oninput="rangeNumInput(this)" >
                </div>
            </div>
        </div>
        <!-- 3rd row -->
        <div class="form-group col-sm-4">
            <label class="control-label" for="irval">Amount of Water (mm) *</label>
            <div class="input-group col-sm-12">
                <div class="col-sm-7">
                    <input type="range" name="irval" step="0.1" max="100" min="0" class="form-control" value="" placeholder="Irrigation amount, depth of water (mm)" data-toggle="tooltip" title="Irrigation amount, depth of water (mm)" oninput="rangeNumInput(this)">
                </div>
                <div class="col-sm-5">
                    <input type="number" name="irval" step="0.1" max="999" min="0" class="form-control event-input-item" value="" oninput="rangeNumInput(this)" >
                </div>
            </div>
        </div>
        <div class="form-group col-sm-6">
            <label class="control-label" for="irop">Opertion *</label>
            <div class="input-group col-sm-12">
                <select name="irop" class="form-control event-input-item" data-placeholder="Choose a fertilizer material...">
                    <option value=""></option>
                    <option value="IR001">Furrow, mm</option>
                    <option value="IR002">Alternating furrows, mm</option>
                    <option value="IR003">Flood, mm</option>
                    <option value="IR004">Sprinkler, mm</option>
                    <option value="IR005">Drip or trickle, mm</option>
                    <option value="IR006">Flood depth, mm</option>
                    <option value="IR007">Water table depth, mm</option>
                    <option value="IR008">Percolation rate, mm day-1</option>
                    <option value="IR009">Bund height, mm</option>
                    <option value="IR010">Puddling (for Rice only)</option>
                    <option value="IR011">Constant flood depth, mm</option>
                    <option value="IR012">Subsurface (burried) drip, mm</option>
                    <option value="IR999">Irrigation method unknown/not given</option>
                </select>
            </div>
        </div>
    </div>
    <p>&nbsp;</p>
</div>

<!-- Fertilizer Dialog -->
<div class="event-input-fertilizer" hidden>
    <p></p>
    <div class="col-sm-12">
        <!-- 1st row -->
        <div class="form-group col-sm-12">
            <label class="control-label">Event Name</label>
            <div class="input-group col-sm-12">
                <input type="text" name="content" class="form-control event-input-item" value="" >
            </div>
        </div>
        <!-- 2nd row -->
        <div class="form-group col-sm-4">
            <label class="control-label">Event Type</label>
            <div class="input-group col-sm-12">
                <input type="text" name="event" class="form-control event-input-item" value="fertilizer" readonly >
            </div>
        </div>
        <div class="form-group col-sm-4">
            <label class="control-label" for="cul_id">Event Date</label>
            <div class="input-group col-sm-12">
                <input type="date" name="start" class="form-control event-input-item" value="">
            </div>
        </div>
        <div class="form-group col-sm-4">
            <label class="control-label" for="fedep">Depth (cm)</label>
            <div class="input-group col-sm-12">
                <div class="col-sm-7">
                    <input type="range" name="fedep" step="1" max="300" min="1" class="form-control" value="" placeholder="Fertilizer applied depth (cm)" data-toggle="tooltip" title="Fertilizer applied depth (cm)" oninput="rangeNumInput(this)">
                </div>
                <div class="col-sm-5">
                    <input type="number" name="fedep" step="1" max="999" min="1" class="form-control event-input-item" value="" oninput="rangeNumInput(this)" >
                </div>
            </div>
        </div>
        <!-- 3rd row -->
        <div class="form-group col-sm-6">
            <label class="control-label" for="fecd">Fertilizer Material *</label>
            <div class="input-group col-sm-12">
                <select name="fecd" class="form-control event-input-item" data-placeholder="Choose a fertilizer material...">
                    <option value=""></option>
                    <option value="FE001">Ammonium nitrate</option>
                    <option value="FE002">Ammonium sulfate</option>
                    <option value="FE003">Ammonium nitrate sulfate</option>
                    <option value="FE004">Anhydrous ammonia</option>
                    <option value="FE005">Urea</option>
                    <option value="FE006">Diammnoium phosphate</option>
                    <option value="FE007">Monoammonium phosphate</option>
                    <option value="FE008">Calcium nitrate</option>
                    <option value="FE009">Aqua ammonia</option>
                    <option value="FE010">Urea ammonium nitrate solution</option>
                    <option value="FE011">Calcium ammonium nitrate solution</option>
                    <option value="FE012">Ammonium polyphosphate</option>
                    <option value="FE013">Single super phosphate</option>
                    <option value="FE014">Triple super phosphate</option>
                    <option value="FE015">Liquid phosphoric acid</option>
                    <option value="FE016">Potassium chloride</option>
                    <option value="FE017">Potassium nitrate</option>
                    <option value="FE018">Potassium sulfate</option>
                    <option value="FE019">Urea super granules</option>
                    <option value="FE020">Dolomitic limestone</option>
                    <option value="FE021">Rock phosphate</option>
                    <option value="FE022">Calcitic limestone</option>
                    <option value="FE024">Rhizobium</option>
                    <option value="FE026">Calcium hydroxide</option>
                    <option value="FE051">Urea super granules</option>
                </select>
            </div>
        </div>
        <div class="form-group col-sm-6">
            <label class="control-label" for="feacd">Fertilizer Applications *</label>
            <div class="input-group col-sm-12">
                <select name="feacd" class="form-control event-input-item" data-placeholder="Choose a fertilizer application...">
                    <option value=""></option>
                    <option value="AP001">Broadcast, not incorporated</option>
                    <option value="AP002">Broadcast, incorporated</option>
                    <option value="AP003">Banded on surface</option>
                    <option value="AP004">Banded beneath surface</option>
                    <option value="AP005">Applied in irrigation water</option>
                    <option value="AP006">Foliar spray</option>
                    <option value="AP007">Bottom of hole</option>
                    <option value="AP008">On the seed</option>
                    <option value="AP009">Injected</option>
                    <option value="AP011">Broadcast on flooded/saturated soil, none in soil</option>
                    <option value="AP012">Broadcast on flooded/saturated soil, 15% in soil</option>
                    <option value="AP013">Broadcast on flooded/saturated soil, 30% in soil</option>
                    <option value="AP014">Broadcast on flooded/saturated soil, 45% in soil</option>
                    <option value="AP015">Broadcast on flooded/saturated soil, 60% in soil</option>
                    <option value="AP016">Broadcast on flooded/saturated soil, 75% in soil</option>
                    <option value="AP017">Broadcast on flooded/saturated soil, 90% in soil</option>
                    <option value="AP018">Band on saturated soil,2cm flood, 92% in soil</option>
                    <option value="AP019">Deeply placed urea super granules/pellets, 95% in soil</option>
                    <option value="AP020">Deeply placed urea super granules/pellets, 100% in soil</option>
                    <option value="AP999">Application method unknown/not given</option>
                </select>
            </div>
        </div>
        <!-- 3rd row -->
        <div class="form-group col-sm-4">
            <label class="control-label" for="feamn">Nitrogen (kg/ha)</label>
            <div class="input-group col-sm-12">
                <div class="col-sm-7">
                    <input type="range" name="feamn" step="1" max="999" min="1" class="form-control" value="" placeholder="Nitrogen in applied fertilizer (ka/ha)" data-toggle="tooltip" title="Nitrogen in applied fertilizer (ka/ha)" oninput="rangeNumInput(this)">
                </div>
                <div class="col-sm-5">
                    <input type="number" name="feamn" step="1" max="9999" min="1" class="form-control event-input-item" value="" oninput="rangeNumInput(this)" >
                </div>
            </div>
        </div>
        <div class="form-group col-sm-4">
            <label class="control-label" for="feamp">Phosphorus (kg/ha)</label>
            <div class="input-group col-sm-12">
                <div class="col-sm-7">
                    <input type="range" name="feamp" step="1" max="999" min="1" class="form-control" value="" placeholder="Phosphorus in applied fertilizer (ka/ha)" data-toggle="tooltip" title="Phosphorus in applied fertilizer (ka/ha)" oninput="rangeNumInput(this)">
                </div>
                <div class="col-sm-5">
                    <input type="number" name="feamp" step="1" max="9999" min="1" class="form-control event-input-item" value="" oninput="rangeNumInput(this)" >
                </div>
            </div>
        </div>
        <div class="form-group col-sm-4">
            <label class="control-label" for="feamk">Potassium (kg/ha)</label>
            <div class="input-group col-sm-12">
                <div class="col-sm-7">
                    <input type="range" name="feamk" step="1" max="999" min="1" class="form-control" value="" placeholder="Potassium in applied fertilizer (ka/ha)" data-toggle="tooltip" title="Potassium in applied fertilizer (ka/ha)" oninput="rangeNumInput(this)">
                </div>
                <div class="col-sm-5">
                    <input type="number" name="feamk" step="1" max="9999" min="1" class="form-control event-input-item" value="" oninput="rangeNumInput(this)" >
                </div>
            </div>
        </div>
        <!-- 4th row -->
        <div class="form-group col-sm-4">
            <label class="control-label" for="feamc">Calcium (kg/ha)</label>
            <div class="input-group col-sm-12">
                <div class="col-sm-7">
                    <input type="range" name="feamc" step="1" max="999" min="1" class="form-control" value="" placeholder="Calcium in applied fertilizer (ka/ha)" data-toggle="tooltip" title="Calcium in applied fertilizer (ka/ha)" oninput="rangeNumInput(this)">
                </div>
                <div class="col-sm-5">
                    <input type="number" name="feamc" step="1" max="9999" min="1" class="form-control event-input-item" value="" oninput="rangeNumInput(this)" >
                </div>
            </div>
        </div>
        <div class="form-group col-sm-4">
            <label class="control-label" for="feamo">Other - amount (kg/ha)</label>
            <div class="input-group col-sm-12">
                <div class="col-sm-7">
                    <input type="range" name="feamo" step="1" max="999" min="1" class="form-control" value="" placeholder="Other elements in applied fertilizer (ka/ha)" data-toggle="tooltip" title="Other elements in applied fertilizer (ka/ha)" oninput="rangeNumInput(this)">
                </div>
                <div class="col-sm-5">
                    <input type="number" name="feamo" step="1" max="9999" min="1" class="form-control event-input-item" value="" oninput="rangeNumInput(this)" >
                </div>
            </div>
        </div>
        <div class="form-group col-sm-4">
            <label class="control-label" for="feocd">Other - name</label>
            <div class="input-group col-sm-12">
                <select name="feocd" class="form-control event-input-item" data-placeholder="Choose a type for other element...">
                    <option value=""></option>
                    <option value="Mg">Magnesium</option>
                    <option value="Mn">Manganese</option>
                    <option value="Cd">Cadmium</option>
                    <option value="Zn">Zinc</option>
                    <option value="S">Sulfur</option>
                    <option value="Fe">Iron</option>
                    <option value="Se">Selenium</option>
                    <option value="B">Boron</option>
                </select>
            </div>
        </div>
    </div>
    <p>&nbsp;</p>
</div>

<!-- Harvest Dialog -->
<div class="event-input-harvest" hidden>
    <p></p>
    <div class="col-sm-12">
        <!-- 1st row -->
        <div class="form-group col-sm-12">
            <label class="control-label">Event Name</label>
            <div class="input-group col-sm-12">
                <input type="text" name="content" class="form-control event-input-item" value="" >
            </div>
        </div>
        <!-- 2nd row -->
        <div class="form-group col-sm-4">
            <label class="control-label">Event Type</label>
            <div class="input-group col-sm-12">
                <input type="text" name="event" class="form-control event-input-item" value="harvest" readonly >
            </div>
        </div>
        <div class="form-group col-sm-4">
            <label class="control-label" for="cul_id">Event Date</label>
            <div class="input-group col-sm-12">
                <input type="date" name="start" class="form-control event-input-item" value="">
            </div>
        </div>
        <div class="form-group col-sm-4">
            <label class="control-label" for="hastg">Stage</label>
            <div class="input-group col-sm-12">
                <div class="col-sm-7">
                    <input type="range" name="hastg_num" step="1" max="20" min="1" class="form-control" value="" placeholder="Harvest Stage (code)" data-toggle="tooltip" title="Row spacing (cm)" oninput="rangeNumInputSP(this)">
                </div>
                <div class="col-sm-5">
                    <input type="text" name="hastg" class="form-control event-input-item" value="" readonly>
                </div>
            </div>
        </div>
        <!-- 3rd row -->
        <div class="form-group col-sm-6">
            <label class="control-label" for="hacom">Component</label>
            <div class="input-group col-sm-12">
                <select name="hacom" class="form-control event-input-item" data-placeholder="Choose a harvest component...">
                    <option value=""></option>
                    <option value="C">Canopy</option>
                    <option value="L">Leaves</option>
                    <option value="H">Harvest product</option>
                </select>
            </div>
        </div>
        <div class="form-group col-sm-6">
            <label class="control-label" for="hasiz">Size Group</label>
            <div class="input-group col-sm-12">
                <select name="hasiz" class="form-control event-input-item" data-placeholder="Choose a size group of harvest...">
                    <option value=""></option>
                    <option value="A">All</option>
                    <option value="S">Small - less than 1/3 full size</option>
                    <option value="M">Medium - from 1/3 to 2/3 full size</option>
                    <option value="L">Large - greater than 2/3 full size</option>
                </select>
            </div>
        </div>
        <!-- 4th row -->
        <div class="form-group col-sm-6">
            <label class="control-label" for="happc">Grain Harvest (%)</label>
            <div class="input-group col-sm-12">
                <div class="col-sm-7">
                    <input type="range" name="happc" step="1" max="100" min="1" class="form-control" value="" placeholder="Grain Harvest (%)" data-toggle="tooltip" title="Grain harvest (%)" oninput="rangeNumInput(this)">
                </div>
                <div class="col-sm-5">
                    <input type="number" name="happc" step="1" max="100" min="1" class="form-control event-input-item" value="" oninput="rangeNumInput(this)" >
                </div>
            </div>
        </div>
        <div class="form-group col-sm-6">
            <label class="control-label" for="habpc">Byproduct takeoff (%)</label>
            <div class="input-group col-sm-12">
                <div class="col-sm-7">
                    <input type="range" name="habpc" step="1" max="100" min="1" class="form-control" value="" placeholder="Byproduct takeoff (%)" data-toggle="tooltip" title="Byproduct takeoff (%)" oninput="rangeNumInput(this)">
                </div>
                <div class="col-sm-5">
                    <input type="number" name="habpc" step="1" max="100" min="1" class="form-control event-input-item" value="" oninput="rangeNumInput(this)">
                </div>
            </div>
        </div>
    </div>
    <p>&nbsp;</p>
</div>
