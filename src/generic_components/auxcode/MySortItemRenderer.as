package generic_components.auxcode
{
	import
	mx.controls.advancedDataGridClasses.AdvancedDataGridSortItemRenderer;
	import mx.core.UITextField;
	
	public class MySortItemRenderer extends
		AdvancedDataGridSortItemRenderer
	{
		public function MySortItemRenderer()
		{
		}
		
		override protected function childrenCreated():void
		{
			super.childrenCreated();
			
			// Get reference to sort number text field
			var sortOrderTextField:UITextField = this.getChildAt(0) as
				UITextField;
			
			if (sortOrderTextField != null)
			{
				// Hide sort number text field
				sortOrderTextField.includeInLayout = false;
				sortOrderTextField.visible = false;
			}
		}
	} 
}