package core
{
	import generic_components.AdvancedDataGridCustom;
	
	import mx.collections.ArrayCollection;
	import mx.controls.advancedDataGridClasses.AdvancedDataGridHeaderRenderer;
	import mx.printing.FlexPrintJob;
	import mx.printing.FlexPrintJobScaleType;
	import mx.printing.PrintAdvancedDataGrid;
	import mx.printing.PrintDataGrid;
	
	import spark.components.Application;
	
	public class PrintAdvancedGridCustom
	{
		private var myPrintDataGrid:PrintAdvancedDataGrid;
		private var myPrintJob:FlexPrintJob;
		private var dataGrid:AdvancedDataGridCustom;
		
		public function PrintAdvancedGridCustom(dg:AdvancedDataGridCustom)
		{
			this.dataGrid=dg;
		}
		
		public function doPrint():void {
			myPrintJob = new FlexPrintJob();
			
			myPrintDataGrid = new PrintAdvancedDataGrid();
			myPrintDataGrid.source=this.dataGrid;
			
			StageReference.instance.addElement(myPrintDataGrid);
			
			if (myPrintJob.start()) {	
				var pageWidth:Number=myPrintJob.pageWidth;
				myPrintDataGrid.width=pageWidth;
				myPrintJob.addObject(myPrintDataGrid, FlexPrintJobScaleType.MATCH_WIDTH);
				myPrintDataGrid.invalidateDisplayList();
				//myPrintDataGrid.invalidateProperties();
				StageReference.instance.callLater(function():void{
				myPrintJob.send();
				StageReference.instance.removeElement(myPrintDataGrid);
				});
			}
			else
			{
				StageReference.instance.removeElement(myPrintDataGrid);
				
			}
		}
		
	}
}