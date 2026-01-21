import { reactWidget } from 'reactR';

// Register all Community features
import { ModuleRegistry, AllCommunityModule } from "ag-grid-community";
ModuleRegistry.registerModules([AllCommunityModule]);

// Register all Community and Enterprise features
// import { AllEnterpriseModule } from 'ag-grid-enterprise';
// ModuleRegistry.registerModules([AllEnterpriseModule]);

import { AgGridReact } from 'ag-grid-react';


class AgGridWrapper extends React.Component {
   constructor(props) {
      super(props);

      this.state = {
         gridOptions: props.x.gridOptions
      };
      this.gridRef = React.createRef();
   }

   render() {
      const { gridOptions } = this.state;
      return (
         <AgGridReact
            ref={this.gridRef}
            gridOptions={gridOptions}
         />
      );
   }
}


reactWidget('aggrid', 'output', {Aggrid: AgGridWrapper}, {});
