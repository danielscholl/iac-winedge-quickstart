require('tap').mochaGlobals();
const should = require('should');

const template = require('../azuredeploy.json');
const parameters = require('../azuredeploy.parameters.json');

describe('iac-tsi-quickstart', () => {
  context('template file', () => {
    it('should exist', () => should.exist(template));

    context('has expected properties', () => {
      it('should have property $schema', () => should.exist(template.$schema));
      it('should have property contentVersion', () => should.exist(template.contentVersion));
      it('should have property parameters', () => should.exist(template.parameters));
      it('should have property variables', () => should.exist(template.variables));
      it('should have property resources', () => should.exist(template.resources));
      it('should have property outputs', () => should.exist(template.outputs));
    });

    context('defines the expected parameters', () => {
      const actual = Object.keys(template.parameters);

      it('should have 11 parameters', () => actual.length.should.be.exactly(11));
      it('should have a initials', () => actual.should.containEql('initials'));
      it('should have a random', () => actual.should.containEql('random'));
      it('should have a storageAccountType', () => actual.should.containEql('storageAccountType'));
      it('should have a vnetPrefix', () => actual.should.containEql('vnetPrefix'));
      it('should have a subnetPrefix', () => actual.should.containEql('subnetPrefix'));
      it('should have a numberOfInstances', () => actual.should.containEql('numberOfInstances'));
      it('should have a vmName', () => actual.should.containEql('vmName'));
      it('should have a vmSize', () => actual.should.containEql('vmSize'));
      it('should have a osVersion', () => actual.should.containEql('osVersion'));
      it('should have a adminUsername', () => actual.should.containEql('adminUsername'));
      it('should have a adminPassword', () => actual.should.containEql('adminPassword'));
    });

    context('defines the expected variables', () => {
      const actual = Object.keys(template.variables);

      it('should have 17 variables', () => actual.length.should.be.exactly(17));
      it('should have a StorageAccountName', () => actual.should.containEql('StorageAccountName'));
      it('should have a StorageId', () => actual.should.containEql('StorageId'));
      it('should have a NsgName', () => actual.should.containEql('NsgName'));
      it('should have a NsgId', () => actual.should.containEql('NsgId'));
      it('should have a VNetName', () => actual.should.containEql('VNetName'));
      it('should have a VNetId', () => actual.should.containEql('VNetId'));
      it('should have a SubnetName', () => actual.should.containEql('SubnetName'));
      it('should have a SubNetId', () => actual.should.containEql('SubNetId'));
      it('should have a PublicIpName', () => actual.should.containEql('PublicIpName'));
      it('should have a NicName', () => actual.should.containEql('NicName'));
      it('should have a VmName', () => actual.should.containEql('VmName'));
    });

    context('creates the expected resources', () => {
      const actual = template.resources.map(resource => resource.type);

      it('should have 7 resources', () => actual.length.should.be.exactly(7));
      it('should create Microsoft.Storage/storageAccounts', () => actual.should.containEql('Microsoft.Storage/storageAccounts'));
      it('should create Microsoft.Network/networkSecurityGroups', () => actual.should.containEql('Microsoft.Network/networkSecurityGroups'));
      it('should create Microsoft.Network/virtualNetworks', () => actual.should.containEql('Microsoft.Network/virtualNetworks'));
      it('should create Microsoft.Network/publicIPAddresses', () => actual.should.containEql('Microsoft.Network/publicIPAddresses'));
      it('should create Microsoft.Network/networkInterfaces', () => actual.should.containEql('Microsoft.Network/networkInterfaces'));
      it('should create Microsoft.Compute/virtualMachines', () => actual.should.containEql('Microsoft.Compute/virtualMachines'));
    });
  });

  context('parameters file', (done) => {
    it('should exist', () => should.exist(parameters));

    context('has expected properties', () => {
      it('should define $schema', () => should.exist(parameters.$schema));
      it('should define contentVersion', () => should.exist(parameters.contentVersion));
      it('should define parameters', () => should.exist(parameters.parameters));
    });
  });
});