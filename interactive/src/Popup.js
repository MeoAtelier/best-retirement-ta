import React from 'react';
import Dialog from 'material-ui/Dialog';
import FlatButton from 'material-ui/FlatButton';
import {
  Table,
  TableBody,
  TableRow,
  TableRowColumn,
} from 'material-ui/Table';

/**
 * Dialog with action buttons. The actions are passed in as an array of React objects,
 * in this example [FlatButtons](/#/components/flat-button).
 *
 * You can also close this dialog by clicking outside the dialog, or with the 'Esc' key.
 */
export default class DialogExampleSimple extends React.Component {

  render() {
    const { selected, hideDetail } = this.props;
        console.log(selected);
    const actions = [
      <FlatButton
        label="Close"
        primary={true}
        onClick={hideDetail}
      />,
    ];

    return (selected === null ? <div /> :
      <div>
        <Dialog
          title={this.props.selected.name}
          actions={actions}
          modal={false}
          open={true}
          onRequestClose={hideDetail}
        >
          <Table height="800">
            <TableBody displayRowCheckbox={false} >
              <TableRow>
                <TableRowColumn>Sunshine: average annual hours</TableRowColumn>
                <TableRowColumn style={{textAlign: 'right'}}>{selected.sunshine.toLocaleString()}</TableRowColumn>
              </TableRow>
              <TableRow>
                <TableRowColumn>Burglaries: per 100,000 people</TableRowColumn>
                <TableRowColumn style={{textAlign: 'right'}}>{selected.burglary.toLocaleString()}</TableRowColumn>
              </TableRow>
              <TableRow>
                <TableRowColumn>Rates: annual average</TableRowColumn>
                <TableRowColumn style={{textAlign: 'right'}}>{selected.rates.toLocaleString()}</TableRowColumn>
              </TableRow>
              <TableRow>
                <TableRowColumn>Over 65: proportion of population</TableRowColumn>
                <TableRowColumn style={{textAlign: 'right'}}>{`${selected.over65pc}%`}</TableRowColumn>
              </TableRow>
              <TableRow>
                <TableRowColumn>Over 65: total</TableRowColumn>
                <TableRowColumn style={{textAlign: 'right'}}>{`${selected.over65pop.toLocaleString()}`}</TableRowColumn>
              </TableRow>
              <TableRow>
                <TableRowColumn>Value: median for 2 bedroom property</TableRowColumn>
                <TableRowColumn style={{textAlign: 'right'}}>{`$${selected.medianValue.toLocaleString()}`}</TableRowColumn>
              </TableRow>
              <TableRow>
                <TableRowColumn>Properties: total 2 bedroom properties</TableRowColumn>
                <TableRowColumn style={{textAlign: 'right'}}>{`${selected.totalProperties.toLocaleString()}`}</TableRowColumn>
              </TableRow>
              <TableRow>
                <TableRowColumn>DHB: staff per 100,000 people</TableRowColumn>
                <TableRowColumn style={{textAlign: 'right'}}>{`${selected.dhbStaff.toLocaleString()}`}</TableRowColumn>
              </TableRow>
            </TableBody>
          </Table>
        </Dialog>
      </div>
    );
  }
}
