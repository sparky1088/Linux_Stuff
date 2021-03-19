/* This is the function to import a csv to the first sheet (the csv name is equipment.csv) */

function importCSVtoGoogleSheet() {
  //This will select the active Google Spreadsheet along with the range from Column A to AB
  var sheet = SpreadsheetApp.getActiveSpreadsheet().getSheetByName("All").getRange("A:AB");
  //This will clear all the contents for the above range
  sheet.clearContent();
  //This will search the drive to find the file with the name Test.csv all the contents for the above range
  var file = DriveApp.getFilesByName("equipment.csv").next();
  //This will parse the data from CSV as string 
  var csvData = Utilities.parseCsv(file.getBlob().getDataAsString());
  //This will again select the active Google Spreadsheet
  var sheet = SpreadsheetApp.getActiveSpreadsheet().getSheetByName("All");
  //This will select the range same as CSV file and import the data from CSV to spreadsheet
  sheet.getRange(1,1,csvData.length, csvData[0].length).setValues(csvData);
}
