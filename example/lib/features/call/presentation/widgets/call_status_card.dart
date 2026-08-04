import 'package:flutter/material.dart';
import '../../domain/entities/call_flow_state.dart';

class CallStatusCard extends StatelessWidget {
  final String message;
  final CallFlowState state;

  const CallStatusCard({
    super.key,
    required this.message,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _getBackgroundColor(state),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _getBorderColor(state), width: 2),
      ),
      child: Row(
        children: [
          _buildIcon(state),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _getTitle(state),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: _getTextColor(state),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  message,
                  style: TextStyle(
                    fontSize: 16,
                    color: _getTextColor(state),
                  ),
                ),
              ],
            ),
          ),
          if (state is SearchingState || state is CallingState)
            const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
        ],
      ),
    );
  }

  Widget _buildIcon(CallFlowState state) {
    IconData icon;
    Color color;

    if (state is IdleState) {
      icon = Icons.phone;
      color = Colors.blue;
    } else if (state is SearchingState) {
      icon = Icons.search;
      color = Colors.orange;
    } else if (state is ReadyToCallState) {
      icon = Icons.phone_forwarded;
      color = Colors.green;
    } else if (state is CallingState) {
      icon = Icons.call;
      color = Colors.green;
    } else if (state is EndedState) {
      if (state.reason == EndReason.completed) {
        icon = Icons.check_circle;
        color = Colors.green;
      } else {
        icon = Icons.error;
        color = Colors.red;
      }
    } else {
      icon = Icons.info;
      color = Colors.grey;
    }

    return Icon(icon, color: color, size: 32);
  }

  String _getTitle(CallFlowState state) {
    if (state is IdleState) return 'Ready';
    if (state is SearchingState) return 'Searching';
    if (state is ReadyToCallState) return 'Connecting';
    if (state is CallingState) return 'In Call';
    if (state is EndedState) {
      if (state.reason == EndReason.completed) return 'Completed';
      return 'Error';
    }
    return 'Status';
  }

  Color _getBackgroundColor(CallFlowState state) {
    if (state is EndedState && state.reason != EndReason.completed) {
      return Colors.red.withOpacity(0.1);
    }
    if (state is CallingState) {
      return Colors.green.withOpacity(0.1);
    }
    return Colors.blue.withOpacity(0.1);
  }

  Color _getBorderColor(CallFlowState state) {
    if (state is EndedState && state.reason != EndReason.completed) {
      return Colors.red;
    }
    if (state is CallingState) {
      return Colors.green;
    }
    return Colors.blue;
  }

  Color _getTextColor(CallFlowState state) {
    if (state is EndedState && state.reason != EndReason.completed) {
      return Colors.red.shade700;
    }
    if (state is CallingState) {
      return Colors.green.shade700;
    }
    return Colors.blue.shade700;
  }
}
