import { Routes } from '@angular/router';
import { TicketsComponent } from './features/tickets/tickets.component';
import { KnowledgebaseComponent } from './features/knowledgebase/knowledgebase.component';
import { LiveLogsComponent } from './features/live-logs/live-logs.component';

export const routes: Routes = [
  { path: '', pathMatch: 'full', redirectTo: 'tickets' },
  { path: 'tickets', component: TicketsComponent },
  { path: 'knowledgebase', component: KnowledgebaseComponent },
  { path: 'logs', component: LiveLogsComponent },
  { path: '**', redirectTo: 'tickets' }
];
