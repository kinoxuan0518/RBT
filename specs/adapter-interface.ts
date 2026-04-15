export type RbtMode =
  | "MORNING_RUN"
  | "EVENING_RUN"
  | "FULL_RUN"
  | "STATUS_QUERY"
  | "STOP"
  | "RETRY_SYNC"
  | "EVOLVE";

export type StageId = "A" | "B" | "C" | "D";

export type StageStatus = "STARTED" | "DONE" | "FAILED" | "SKIPPED" | "STOPPED";

export interface ProgressEvent {
  eventType:
    | "run_started"
    | "stage_started"
    | "stage_completed"
    | "stage_failed"
    | "run_completed"
    | "run_failed"
    | "run_stopped"
    | "suggestion_generated";
  runId: string;
  mode: RbtMode;
  status: StageStatus;
  timestamp: string;
  stage?: StageId;
  note?: string;
  counts?: Record<string, number>;
  humanInterventionRequired?: boolean;
  errors?: string[];
}

export interface RunContext {
  runId: string;
  mode: RbtMode;
  preferences?: Record<string, string | boolean | number>;
  metadata?: Record<string, unknown>;
}

export interface TaskResult {
  ok: boolean;
  note?: string;
  counts?: Record<string, number>;
  errors?: string[];
  shouldStop?: boolean;
  needsHuman?: boolean;
}

export interface Suggestion {
  suggestionId: string;
  priority: "critical" | "high" | "medium" | "low";
  category: "relax_rule" | "tighten_rule" | "repair_rule" | "expand_sources" | "no_action";
  triggerMetric: string;
  currentRule?: string;
  proposedChange: string;
  expectedImpact?: string;
  confidence: "high" | "medium" | "low";
  evidence: string[];
  risk?: string;
  status: "pending" | "approved" | "rejected" | "applied";
}

export interface TaskAdapter {
  name: string;
  runStage(stage: StageId, context: RunContext): Promise<TaskResult>;
  getStatus?(context: RunContext): Promise<TaskResult>;
  stop?(context: RunContext): Promise<TaskResult>;
}

export interface OutcomeStoreAdapter {
  name: string;
  readOutcomes(context: RunContext): Promise<Record<string, unknown>[]>;
  writeSuggestions?(suggestions: Suggestion[], context: RunContext): Promise<void>;
}

export interface NotificationAdapter {
  name: string;
  emit(event: ProgressEvent, context: RunContext): Promise<void>;
  summarize?(summary: string, context: RunContext): Promise<void>;
}

export interface SafetyAdapter {
  name: string;
  assertPreflight(context: RunContext): Promise<void>;
  checkStop(context: RunContext): Promise<boolean>;
  checkHardStop(context: RunContext): Promise<{ stop: boolean; reason?: string }>;
}

export interface RuleStoreAdapter {
  name: string;
  readRules(context: RunContext): Promise<Record<string, unknown>>;
  writeRules?(patch: Record<string, unknown>, context: RunContext): Promise<void>;
}
