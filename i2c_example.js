import { MCP2221 } from './johntalton/mcp2221/index.js'
import { I2CBusMCP2221 } from './johntalton/i2c-bus-mcp2221/index.js'
import { WebHIDStreamSource } from './johntalton/util/hid-stream.js'

  document.getElementById('connect-button').addEventListener('click', async () => {
    try {
            const hidDevice = await navigator.hid.requestDevice({
                filters: [
                    { vendorId: 0x04D8, productId: 0x00DD }//, // Filter by vendor and product ID
                    //{ usagePage: 0x01, usage: 0x06 } // Filter by usage page and usage
                ]
                })[0]
            const source = new WebHIDStreamSource(hidDevice) // or NodeHIDStreamSource
            const device = MCP2221.from(source) // create device
            const bus = I2CBusMCP2221.from(device) // create virtual bus from device
        }
    catch (error) {
        console.error(error); // The SecurityError should no longer appear here
        }
  });
