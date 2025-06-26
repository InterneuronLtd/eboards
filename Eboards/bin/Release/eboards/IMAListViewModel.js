ko.bindingHandlers.optionsBind = {
	preprocess: function (value, key, addBinding) {
		addBinding('optionsAfterRender', 'function(option, item) { ko.bindingHandlers.optionsBind.applyBindings(option, item, ' + value + ') }');
	},
	applyBindings: function (option, item, bindings) {
		if (item !== undefined) {
			option.setAttribute('data-bind', bindings);
			ko.applyBindings(ko.contextFor(option).createChildContext(item), option);
		}
	}
};


var viewModel = function () {
	var self = this;



	self.DynamicListData = ko.observableArray();
	self.Wards = ko.observableArray();
	self.selectedWard = ko.observable();
	self.ColumnData = ko.observableArray();
	self.TableCSS = ko.observable();
	self.HeaderCSS = ko.observable();
	self.DefaultRowCSS = ko.observable();
	self.IsLoading = ko.observable(true);
	self.IsModalLoading = ko.observable(false);
	self.selectedWard = ko.observable();
	self.eboardencounter = ko.observableArray();
	self.coreencounter = ko.observableArray();
	self.selectedEncounterID = ko.observable();
	self.patientclasscode = ko.observable();

	self.eboards_encounter_id = ko.observable();
	self.encounter_id = ko.observable();
	self.wardcode = ko.observable();
	self.bedcode = ko.observable();
	self.originalwardcode = ko.observable();
	self.originalbedcode = ko.observable();
	self.edd = ko.observable();
	self.returnwardcode = ko.observable();
	self.originalreturnwardcode = ko.observable();
	self.returnbedcode = ko.observable();
	self.originalreturnbedcode = ko.observable();
	self.returndate = ko.observable();
	self.returntime = ko.observable();

	self.allocatedwardcode = ko.observable();
	self.originalallocatedwardcode = ko.observable();
	self.allocatedbedcode = ko.observable();
	self.originalallocatedbedcode = ko.observable();
	self.allocateddate = ko.observable();
	self.allocatedtime = ko.observable();

	self.aliasfirstname = ko.observable();
	self.aliaslastname = ko.observable();
	self.likestobeknownas = ko.observable();
	self.returncode = ko.observable();
	self.Beds = ko.observableArray();
	self.ReturnBeds = ko.observableArray();
	self.AllocatedBeds = ko.observableArray();
	self.admittedWardDisplay = ko.observable();
	self.admittedBedDisplay = ko.observable();
	self.allocatedWardDisplay = ko.observable();
	self.allocatedBedDisplay = ko.observable();
	self.allocatedBedDisplay = ko.observable();
	self.allocatedDateDisplay = ko.observable();
	self.allocatedTimeDisplay = ko.observable();
	self.hasbeeninbed = ko.observable();

	self.moveDate = ko.observable();
	self.moveHour = ko.observable();
	self.moveMin = ko.observable();
	self.bedtransferdatetime = ko.observable();


	self.getReturnBeds = function () {
		$.when(
			GetReturnBeds()
		).done(
			function (
				Beds
			) {

				self.ReturnBeds(Beds);
			});
	};

	self.getAllocatedBeds = function () {
		$.when(
			GetAllocatedBeds()
		).done(
			function (
				Beds
			) {

				self.AllocatedBeds(Beds);
			});
	};

	self.getBeds = function () {
		$.when(
			GetBeds()
		).done(
			function (
				Beds
			) {
				self.Beds(Beds);
			});
	};

	self.getColumnsAndQuestions = function () {

		self.ColumnData('');
		self.DynamicListData('');



		$.when(

			GetWards()
		).done(
			function (

				Wards
			) {

				self.Wards(Wards);

				$.when(

					GetBedBoardDetails()
				).done(
					function (

						BedBoard
					) {

						listId = BedBoard.list_id;

						//self.Wards(Wards);

						$.when(
							GetListDetails()
						).done(
							function (
								Details
							) {
								self.TableCSS(Details.tablecssstyle);
								self.HeaderCSS(Details.tableheadercssstyle);
								self.DefaultRowCSS(Details.defaultrowcssstyle);
							});



						$.when(
							GetColumns()
						).done(
							function (
								Columns
							) {
								self.ColumnData(Columns);

							});


						$.when(
							GetListData()
							//,
							//GetColumns()
						).done(
							function (
								ListData
								//,
								//Columns
							) {
								self.DynamicListData(ListData);
								//console.log(ListData);
								//$("#tblList").tablesorter();
								//self.ColumnData(Columns);
								self.IsLoading(false);
								return;
							});


					});

			});
	};

	self.getListOnly = function () {
		self.IsLoading(true);

		$.when(
			GetListData()
			//,
			//GetColumns()
		).done(
			function (
				ListData

				//,
				//Columns
			) {
				//console.log("List Data:" + JSON.stringify(ListData));
				self.DynamicListData(ListData);
				self.IsLoading(false);
				return;
				//console.log(ListData);
				//$("#tblList").tablesorter();
				//self.ColumnData(Columns);

			});

	};

	self.GetBedBoardDetails = function (item) {
		self.IsLoading(true);
		$.when(

			GetBedBoardDetails()
		).done(
			function (

				BedBoard
			) {

				listId = BedBoard.list_id;

				//self.Wards(Wards);

				$.when(
					GetListDetails()
				).done(
					function (
						Details
					) {
						self.TableCSS(Details.tablecssstyle);
						self.HeaderCSS(Details.tableheadercssstyle);
						self.DefaultRowCSS(Details.defaultrowcssstyle);
					});



				$.when(
					GetColumns()
				).done(
					function (
						Columns
					) {
						self.ColumnData(Columns);

					});


				$.when(
					GetListData()
					//,
					//GetColumns()
				).done(
					function (
						ListData
						//,
						//Columns
					) {
						self.DynamicListData(ListData);
						//console.log(ListData);
						$("#tblList").tablesorter();
						//self.ColumnData(Columns);
						self.IsLoading(false);
						return;
					});


			});
	};

	self.columnNames = ko.computed(function () {
		if (self.DynamicListData().length === 0)
			return [];
		var props = [];
		var obj = self.DynamicListData()[0];
		for (var key in obj)
			props.push(key);
		return props;
	});

	self.rowclass = ko.computed(function () {

		//var css = self.DefaultRowCSS();
		//ko.utils.arrayForEach(self.DynamicListData(), function (item) {



		//    item.cssclass = css;


		var css = "";

		ko.utils.arrayForEach(self.DynamicListData(), function (item) {

			var row = item;



			var rowcssfield = JSON.parse(row.col_0).rowcssfield;

			if (rowcssfield === "") {

				css = self.DefaultRowCSS();
			}
			else {
				css = rowcssfield;
			}



			item.cssclass = css;

		});
		return css;
	}, self);





	self.loadQuestions = function (item) {
		//console.log('item:' + JSON.stringify(item));
		questionModalOpen = true;

		var id = JSON.parse(item.col_0).matchedcontext;
		//console.log("id clicked:" + id);
		self.selectedEncounterID(id);
		self.geteboardEncounter();
		getAllQuestions(id);
	};

	self.geteboardEncounter = function () {
		//console.log('self.geteboardEncounter() called');
		$.when(
			GetEBoardEncounterDetails(self.selectedEncounterID())
		).done(
			function (
				ebEncounter
			) {
				//console.log(JSON.stringify(ebEncounter));
				self.eboardencounter(ebEncounter);

				self.eboards_encounter_id(ebEncounter.eboards_encounter_id);
				self.encounter_id(ebEncounter.encounter_id);
				self.originalwardcode(ebEncounter.wardcode);
				self.originalbedcode(ebEncounter.bedcode);
				self.wardcode(ebEncounter.wardcode);
				self.bedcode(ebEncounter.bedcode);
				//console.log("self.bedcode:" + self.bedcode());
				self.edd(ebEncounter.edd);
				self.originalreturnwardcode(ebEncounter.returnwardcode);
				self.returnwardcode(ebEncounter.returnwardcode);
				self.originalreturnbedcode(ebEncounter.returnbedcode);
				self.returnbedcode(ebEncounter.returnbedcode);
				self.returndate(ebEncounter.returndate);
				self.returntime(ebEncounter.returntime);
				self.aliasfirstname(ebEncounter.aliasfirstname);
				self.aliaslastname(ebEncounter.aliaslastname);
				self.likestobeknownas(ebEncounter.likestobeknownas);
				self.returncode(ebEncounter.returncode);

				self.hasbeeninbed(ebEncounter.hasbeeninbed);

				self.admittedWardDisplay("");
				self.admittedBedDisplay("");
				self.allocatedWardDisplay("");
				self.allocatedBedDisplay("");


				self.originalallocatedwardcode(ebEncounter.allocatedwardcode);
				self.originalallocatedbedcode(ebEncounter.allocatedbedcode);

				self.allocatedwardcode(ebEncounter.allocatedwardcode);
				self.allocatedbedcode(ebEncounter.allocatedbedcode);
				self.allocateddate(ebEncounter.allocateddate);
				self.allocatedtime(ebEncounter.allocatedtime);

				//coreencounter

				$.when(
					GeCoreEncounterDetails(self.selectedEncounterID())
				).done(
					function (
						encounter
					) {
						try {
							self.coreencounter(encounter);
							self.patientclasscode(encounter.patientclasscode);
						}
						catch (ex) {

						}
					});

				$.when(
					GetWard(self.wardcode())
				).done(
					function (
						ward
					) {
						try {
							self.admittedWardDisplay(ward[0].warddisplay);
						}
						catch (ex) {

						}
					});

				$.when(
					GetBed(self.bedcode())
				).done(
					function (
						bed
					) {
						try {
							self.admittedBedDisplay(bed[0].bedbaydisplay);
						}
						catch (ex) {

						}
					});


				$.when(
					GetWard(self.allocatedwardcode())
				).done(
					function (
						ward
					) {
						try {
							self.allocatedWardDisplay(ward[0].warddisplay);
						}
						catch (ex) {

						}
					});

				$.when(
					GetBed(self.allocatedbedcode())
				).done(
					function (
						bed
					) {
						try {
							self.allocatedBedDisplay(bed[0].bedbaydisplay);
						}
						catch (ex) {

						}
					});



				//if (!self.admittedWardDisplay()) {
				//    self.admittedWardDisplay("Not Admitted");
				//    self.admittedBedDisplay("");
				//}
				//else if (!self.admittedBedDisplay()) {
				//    self.admittedBedDisplay("Not admitted to bed");
				//}

				//if (!self.allocatedWardDisplay()) {
				//    //self.allocatedWardDisplay("Not Allocated");
				//    self.allocatedWardDisplay("");
				//    self.allocatedBedDisplay("");
				//}
				//else if (!self.allocatedBedDisplay()) {
				//    self.allocatedBedDisplay("");
				//}

			});
	};


	self.formattedReturnDate = ko.computed(function () {
		var val = "";
		if (!self.returndate() == "") {
			val = self.returndate().substring(0, 10);
		}
		else {
			val = null;
		}
		return val;
	}, self);

	self.formattedAllocateDateTime = ko.computed(function () {
		var val = "";
		if (!self.allocateddate() == "") {
			val = self.allocateddate().substring(0, 10);
		}
		else {
			val = null;
		}
		return val;
	}, self);



	self.formattedAllocateDateAndTime = ko.computed(function () {
		var val = "";

		//console.log("self.allocateddate():" + self.allocateddate());

		if (self.allocateddate() == null || self.allocateddate() == '' || self.allocateddate() == 'undefined') {
			val = null;
		}
		else {
			val = "On: " + self.allocateddate().substring(8, 10) + '/' + self.allocateddate().substring(5, 7) + '/' + self.allocateddate().substring(0, 4);

			if (self.allocatedtime() == null || self.allocatedtime() == '' || self.allocatedtime() == 'undefined') {
				val = val;
			}
			else {
				val += " at " + self.allocatedtime();
			}



		}
		return val;
	}, self);

	self.formattedEDD = ko.computed(function () {
		var val = "";
		if (!self.edd() == "") {
			val = self.edd().substring(0, 10);
		}
		else {
			val = null;
		}
		return val;
	}, self);


};

