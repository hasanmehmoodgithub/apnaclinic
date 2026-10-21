import '../../domain/entities/apna_clinic_ai_card_entity.dart';
import '../../domain/entities/apna_clinic_ai_home_tile_entity.dart';
import '../../domain/entities/apna_clinic_ai_session_entity.dart';
import '../../domain/entities/apna_clinic_ai_turn_entity.dart';
import '../models/apna_clinic_ai_session_model.dart';
import '../models/apna_clinic_ai_turn_model.dart';

extension ApnaClinicAiSessionModelMapper on ApnaClinicAiSessionModel {
  ApnaClinicAiSessionEntity toEntity() {
    return ApnaClinicAiSessionEntity(
      sessionId: sessionId,
      conversationId: conversationId,
      isGuest: isGuest,
      assistantName: assistantName,
      suggestions: suggestions,
      welcomeMessage: welcomeMessage,
      voiceEnabled: voiceEnabled,
      homeTiles: homeTiles
          .map(
            (tile) => ApnaClinicAiHomeTileEntity(
              id: tile.id,
              title: tile.title,
              send: tile.send,
              subtitle: tile.subtitle,
            ),
          )
          .toList(),
    );
  }
}

extension ApnaClinicAiTurnModelMapper on ApnaClinicAiTurnModel {
  ApnaClinicAiTurnEntity toEntity() {
    return ApnaClinicAiTurnEntity(
      reply: reply,
      status: status,
      intent: intent,
      failureCode: failureCode,
      quickActions: quickActions
          .map(
            (item) => ApnaClinicAiQuickActionEntity(
              label: item.label,
              send: item.send,
            ),
          )
          .toList(),
      doctors: doctors
          .map(
            (item) => ApnaClinicAiDoctorCardEntity(
              id: item.id,
              kind: item.kind,
              name: item.name,
              send: item.send,
              specialty: item.specialty,
              years: item.years,
              fee: item.fee,
              rating: item.rating,
              imageUrl: item.imageUrl,
              badge: item.badge,
              description: item.description,
              cta: item.cta,
            ),
          )
          .toList(),
      slots: slots
          .map(
            (item) => ApnaClinicAiSlotEntity(label: item.label, send: item.send),
          )
          .toList(),
      slotDays: slotDays
          .map(
            (day) => ApnaClinicAiSlotDayEntity(
              date: day.date,
              slots: day.slots
                  .map(
                    (item) => ApnaClinicAiSlotEntity(
                      label: item.label,
                      send: item.send,
                    ),
                  )
                  .toList(),
            ),
          )
          .toList(),
      payments: payments
          .map(
            (item) => ApnaClinicAiPaymentEntity(
              label: item.label,
              send: item.send,
              hint: item.hint,
            ),
          )
          .toList(),
      audioBase64: audioBase64,
      audioMediaType: audioMediaType,
      signInRequired: signInRequired,
      authResumeMessage: authResumeMessage,
      authDeepLink: authDeepLink,
    );
  }
}
