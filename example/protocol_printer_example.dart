import 'package:protocol_printer/protocol_printer.dart';


void main() {
	try {
		final printer = PrintProtocol(bytePerLine: 4, fieldList: [
			const Field(name: 'happy', useBitSize: 4),
			const Field(name: 'happy', useBitSize: 4),
			const Field(name: 'happy', useByteSize: 1),
			const Field(name: 'happy', useByteSize: 1),
			const Field(name: 'happy', useByteSize: 1),
			const Field(name: 'happy', useByteSize: 1),
			const Field(name: 'hapy', useByteSize: 2),
			const Field(name: 'hay', useByteSize: 1),
			const Field(name: 'py', useByteSize: 1),
			const Field(name: 'happy', useByteSize: 1),
			const Field(name: 'happy', useByteSize: 1),
			const Field(name: 'happy', useByteSize: 1),
		]);
		print(printer.getProtocolStr());
		print('');
		print(printer.getProtocolInfo());
	}
	catch(e) {
		print(e);
	}
}
