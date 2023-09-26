import 'package:flutter/widgets.dart';
import './warp.dart';

class WarpData extends StatelessWidget {
	final Warp props;

	const WarpData({
		super.key,
		required this.props,
	});

	@override
	Widget build(BuildContext context) {
		return Column(
			children: [
				Text('Name: ${props.name}'),
                Text('Rarity: ${props.rankType}'),
                Text('ID: ${props.id}'),
                Text('Time: ${props.time}'),
                Text('Item Type: ${props.itemType}')
			],
		);
	}
}